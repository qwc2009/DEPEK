#!/system/bin/sh

# KSU 模块安装脚本
ui_print "📶 正在安装 NetMonitor v1.0..."
ui_print "📡 实时流量监测 + Web UI"

# 创建数据目录
mkdir -p /data/local/tmp/netmonitor

# 设置权限
set_perm_recursive $MODPATH 0 0 0755 0755
set_perm $MODPATH/service.sh 0 0 0755

ui_print "✅ 安装完成！"
ui_print "🌐 访问 http://127.0.0.1:8080 查看流量"
