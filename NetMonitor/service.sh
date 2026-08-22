#!/system/bin/sh

MODDIR=${0%/*}
TMP_RX="/data/local/tmp/netmonitor/rx"
TMP_TX="/data/local/tmp/netmonitor/tx"
TMP_LAST_RX="/data/local/tmp/netmonitor/last_rx"
TMP_LAST_TX="/data/local/tmp/netmonitor/last_tx"

# 初始化
mkdir -p /data/local/tmp/netmonitor
echo 0 > "$TMP_RX"
echo 0 > "$TMP_TX"
echo 0 > "$TMP_LAST_RX"
echo 0 > "$TMP_LAST_TX"

# 流量采集函数
update_traffic() {
    local rx=0 tx=0
    while read -r line; do
        case "$line" in
            wlan0:* | rmnet0:* | eth0:*)
                set -- $line
                rx=$((rx + ${2}))
                tx=$((tx + ${10}))
                ;;
        esac
    done < /proc/net/dev
    echo "$rx" > "$TMP_RX"
    echo "$tx" > "$TMP_TX"
}

# 后台循环采集
while true; do
    update_traffic
    sleep 1
done &

# 启动 Web 服务（用 busybox httpd）
if command -v busybox >/dev/null 2>&1; then
    cd "$MODDIR/web"
    busybox httpd -p 8080 -h "$MODDIR/web" &
else
    # 备用方案：用 nc 模拟简单 HTTP
    while true; do
        nc -l -p 8080 -e /system/bin/sh -c '
            read request
            while read line; do
                [ "$line" = "" ] && break
            done
            rx=$(cat /data/local/tmp/netmonitor/rx 2>/dev/null || echo 0)
            tx=$(cat /data/local/tmp/netmonitor/tx 2>/dev/null || echo 0)
            echo "HTTP/1.1 200 OK"
            echo "Content-Type: text/html"
            echo ""
            cat /data/adb/modules/netmonitor/web/index.html
        '
    done &
fi
