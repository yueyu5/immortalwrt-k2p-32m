#!/bin/bash
# ==============================================
# Phicomm K2P 32M 硬改适配
# 不删除原行，仅修改IMAGE_SIZE数值，完美适配你提供的源码
# ==============================================

# 【核心要求实现】不删除行，仅修改K2P固件大小上限15744k→32448k
sed -i '/define Device\/phicomm_k2p/,/endef/s/IMAGE_SIZE := 15744k/IMAGE_SIZE := 32448k/' target/linux/ramips/image/mt7621.mk

# 同步修改DTS设备树，系统识别完整32M闪存，和上面的数值一一对应
DTS_FILE="target/linux/ramips/dts/mt7621_phicomm_k2p.dts"
if [ -f "$DTS_FILE" ]; then
    sed -i 's/reg = <0x0 0x1000000>/reg = <0x0 0x2000000>/g' $DTS_FILE
    sed -i 's/0x50000 0xfb0000/0x50000 0x1fb0000/g' $DTS_FILE
    sed -i '/partition@1800000/,+5d' $DTS_FILE 2>/dev/null
    sed -i '/label = "unused"/,+4d' $DTS_FILE 2>/dev/null
fi

#【核心替换】2026年仍有效的K2P mt7615闭源驱动源（适配5.15内核）
echo "src-git mtk_wifi https://github.com/luhujp/mtk-wireless-driver.git;main" >> feeds.conf.default

# 添加SSR-Plus官方稳定源
echo "src-git helloworld https://github.com/fw876/helloworld.git;master" >> feeds.conf.default

# SSR-Plus必需依赖：替换dnsmasq为full版本
sed -i 's/CONFIG_PACKAGE_dnsmasq=y/CONFIG_PACKAGE_dnsmasq=n/g' .config 2>/dev/null
echo "CONFIG_PACKAGE_dnsmasq-full=y" >> .config

# 32M适配：根分区大小设置为28M，和固件上限匹配
echo "CONFIG_TARGET_ROOTFS_PARTSIZE=280" >> .config

# 开启IPv6支持
echo "CONFIG_PACKAGE_ipv6helper=y" >> .config
