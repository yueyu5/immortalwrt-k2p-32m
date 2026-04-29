#!/bin/bash
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#  feeds更新后执行，仅做个性化配置，不修改核心启动参数

echo "开始个性化配置..."

# 修改时区（默认 UTC，改为中国标准时间）
sed -i "s/timezone='UTC'/timezone='CST-8'/g" package/base-files/files/bin/config_generate
sed -i "/timezone='CST-8'/a\\\t\tset system.@system[-1].zonename='Asia/Shanghai'" package/base-files/files/bin/config_generate

# 修改默认语言为中文
sed -i "s/option lang 'en'/option lang 'zh-cn'/g" package/base-files/files/bin/config_generate

# 修改 2.4G 默认 SSID
sed -i 's/ImmortalWrt/opo-2.4G/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh

# 修改 5G 默认 SSID
sed -i 's/ImmortalWrt_5G/opo-5G/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh

# 替换默认软件源为清华源
sed -i 's/downloads.immortalwrt.org/mirrors.tuna.tsinghua.edu.cn\/immortalwrt/g' package/emortal/emortal-files/etc/opkg/distfeeds.conf
sed -i 's/immortalwrt.pro/mirrors.tuna.tsinghua.edu.cn\/immortalwrt/g' package/emortal/emortal-files/etc/opkg/distfeeds.conf

# 修改默认IP（可选，默认192.168.1.1，按需修改）
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate

# 修改默认主机名
sed -i 's/ImmortalWrt/K2P-32M/g' package/base-files/files/bin/config_generate

#屏蔽官方 Argon，只留第三方
rm -rf feeds/luci/themes/luci-theme-argon

echo "个性化配置完成！"
