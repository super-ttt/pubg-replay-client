#!/bin/bash

# 配置参数
SERVER_USER="superx"
REMOTE_PATH="/usr/local/nginx/html/pubgsh-client"
LOCAL_DIST_PATH="build"

echo "开始打包..."
yarn build

echo "上传打包内容到服务器..."
scp -r ${LOCAL_DIST_PATH}/* ${SERVER_USER}:/tmp/h5_temp

# 3. 远程替换并重启 Nginx
ssh ${SERVER_USER} << EOF
    echo "清理旧文件..."
    rm -rf ${REMOTE_PATH}/*
    echo "替换新版本..."
    mv /tmp/h5_temp/* ${REMOTE_PATH}/
    rm -rf /tmp/h5_temp
    echo "重启 Nginx..."
    /usr/local/nginx/sbin/nginx -s reload
    echo "部署完成。"
EOF
