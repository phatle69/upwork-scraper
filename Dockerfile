# Sử dụng image cơ sở của Apify với Node 16
FROM apify/actor-node-basic:16

# Thiết lập thư mục làm việc
WORKDIR /app

# Copy các file cấu hình package; nếu không có package-lock.json thì nó sẽ bỏ qua
COPY package.json package-lock.json* ./

# Làm sạch cache và cài đặt dependencies cho production
RUN npm cache clean --force && \
    if [ -f package-lock.json ]; then \
      npm ci --only=production --no-optional; \
    else \
      npm install --only=production --no-optional; \
    fi

# Copy toàn bộ mã nguồn vào container
COPY . .

# Thiết lập lệnh khởi chạy actor
CMD ["node", "src/main.js"]
