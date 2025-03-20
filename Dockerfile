# Sử dụng image cơ sở do Apify cung cấp với tag latest
FROM apify/actor-node-basic:latest

# Thiết lập thư mục làm việc
WORKDIR /app

# Copy file package.json vào container
COPY package.json ./

# Làm sạch cache và cài đặt các dependencies cần thiết cho production
RUN npm cache clean --force && npm install --only=production --no-optional

# Copy toàn bộ mã nguồn vào container
COPY . .

# Lệnh khởi chạy actor
CMD ["node", "src/main.js"]
