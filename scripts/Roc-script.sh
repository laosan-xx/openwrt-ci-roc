# 修改默认IP & 密码 & 固件名称 & 编译署名
sed -i 's/192.168.1.1/192.168.100.1/g' package/base-files/files/bin/config_generate
sed -i 's/root:.*/root:$y$j9T$Af7ua9RpmpbwXuTepgQP1\/$j2QBmog2BBUJ5hR0q7H5Y5wuGdR\/jUMWjWEVrRQufa7:20196:0:99999:7:::/g' package/base-files/files/etc/shadow
sed -i "s/hostname='.*'/hostname='Tok'/g" package/base-files/files/bin/config_generate
sed -i "s/(\(luciversion || ''\))/(\1) + (' \/ Build by 仨哥')/g" feeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/10_system.js

# 移除要替换的包
rm -rf feeds/packages/net/alist
rm -rf feeds/luci/applications/luci-app-alist
rm -rf feeds/packages/net/adguardhome
rm -rf feeds/packages/net/ariang
rm -rf feeds/packages/net/ddns-scripts
rm -rf package/emortal/luci-app-athena-led

# Git稀疏克隆，只克隆指定目录到本地
function git_sparse_clone() {
  branch="$1" repourl="$2" && shift 2
  git clone --depth=1 -b $branch --single-branch --filter=blob:none --sparse $repourl
  repodir=$(echo $repourl | awk -F '/' '{print $(NF)}')
  cd $repodir && git sparse-checkout set $@
  mv -f $@ ../package
  cd .. && rm -rf $repodir
}

# Alist & AdGuardHome & WolPlus & AriaNg & DDNS & 集客无线AC控制器 & Lucky & 雅典娜LED控制
git clone --depth=1 https://github.com/sbwml/luci-app-alist package/luci-app-alist
git_sparse_clone main https://github.com/kenzok8/small-package adguardhome luci-app-adguardhome
git_sparse_clone main https://github.com/VIKINGYFY/packages luci-app-wolplus
git_sparse_clone master https://github.com/immortalwrt/packages net/ariang
git_sparse_clone openwrt-24.10 https://github.com/immortalwrt/packages net/ddns-scripts
git clone --depth=1 https://github.com/lwb1978/openwrt-gecoosac package/openwrt-gecoosac
git clone --depth=1 https://github.com/gdy666/luci-app-lucky package/luci-app-lucky
git clone --depth=1 https://github.com/NONGFAH/luci-app-athena-led package/luci-app-athena-led
chmod +x package/luci-app-athena-led/root/etc/init.d/athena_led package/luci-app-athena-led/root/usr/sbin/athena-led

./scripts/feeds update -a
./scripts/feeds install -a
