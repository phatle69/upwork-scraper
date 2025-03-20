# Sử dụng image Puppeteer Chrome của Apify
FROM apify/actor-node-puppeteer-chrome:latest

# Chạy với quyền root để chỉnh sửa quyền truy cập thư mục
USER root

# Thiết lập thư mục làm việc và đảm bảo quyền cho nó
WORKDIR /app
RUN mkdir -p /app && chown -R node:node /app

# Copy file package.json vào container
COPY package.json ./

# Dọn dẹp cache và cài đặt các dependency cần thiết cho production
RUN npm cache clean --force && npm install --only=production --no-optional

# Copy toàn bộ mã nguồn dự án vào container
COPY . .

# Chuyển sang user 'node' để chạy Actor
USER node

# Lệnh khởi chạy Actor của bạn
CMD ["node", "src/main.js"]
