# Dùng image cơ sở do Apify cung cấp, đã tích hợp sẵn các thiết lập cho actor
FROM apify/actor-node-basic:latest

# Thiết lập thư mục làm việc
WORKDIR /app

# Copy package.json và package-lock.json trước để tận dụng cache của Docker
COPY package.json package-lock.json* ./

# Cài đặt các dependency cần thiết cho production
RUN npm install --only=production --no-optional

# Copy toàn bộ mã nguồn vào image
COPY . .

# Lệnh khởi chạy actor
CMD ["node", "src/main.js"]
