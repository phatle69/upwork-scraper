# Sử dụng image Node 16 Alpine – đảm bảo phiên bản Node >=16
FROM node:16-alpine

# Cài đặt các công cụ build cần thiết: python3, make, g++
RUN apk add --no-cache python3 make g++

# Thiết lập thư mục làm việc
WORKDIR /app

# Copy file package.json vào container
COPY package.json ./

# Làm sạch cache và cài đặt dependencies cho production
RUN npm cache clean --force && npm install --only=production --no-optional

# Copy toàn bộ mã nguồn dự án vào container
COPY . .

# Lệnh khởi chạy actor của bạn
CMD ["node", "src/main.js"]
