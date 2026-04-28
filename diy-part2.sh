#!/bin/bash
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#  feeds更新后执行，仅做个性化配置，不修改核心启动参数

# 修改默认IP（可选，默认192.168.1.1，按需修改）
# sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate

# 修改默认主机名
sed -i 's/ImmortalWrt/K2P-32M/g' package/base-files/files/bin/config_generate

# 禁用IPv6（可选，按需开启）
# sed -i 's/ipv6=1/ipv6=0/g' package/base-files/files/bin/config_generate

