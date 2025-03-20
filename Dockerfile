# Sử dụng image cơ sở do Apify cung cấp (đã được tối ưu cho Actor)
FROM apify/actor-node-basic:latest

# Thiết lập thư mục làm việc
WORKDIR /app

# Copy package.json và package-lock.json (nếu có) trước để tận dụng cache của Docker
COPY package.json package-lock.json* ./

# Nếu có package-lock.json, npm ci sẽ cài đặt chính xác các dependency được lock
# Nếu không, npm ci sẽ lỗi. Trong trường hợp đó, bạn có thể thay thế bằng "npm install --only=production --no-optional"
RUN if [ -f package-lock.json ]; then npm ci --only=production --no-optional; else npm install --only=production --no-optional; fi

# Copy toàn bộ mã nguồn vào container
COPY . .

# Lệnh khởi chạy Actor
CMD ["node", "src/main.js"]
