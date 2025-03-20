# Sử dụng image cơ sở của Apify chuyên dụng cho Puppeteer
FROM apify/actor-node-puppeteer-chrome:latest

# Thiết lập thư mục làm việc
WORKDIR /app

# Copy file package.json vào container
COPY package.json ./

# Làm sạch cache và cài đặt các dependency cần thiết cho production
RUN npm cache clean --force && npm install --only=production --no-optional

# Copy toàn bộ mã nguồn dự án vào container
COPY . .

# Lệnh khởi chạy actor của bạn
CMD ["node", "src/main.js"]
