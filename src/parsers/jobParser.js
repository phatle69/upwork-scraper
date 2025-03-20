const Apify = require('apify');
const { log } = require('../tools');

exports.jobParser = async ({ page, request, extendOutputFunction, itemCount, maxItems }) => {
    log.debug('Processing job detail page...');

    // Chờ cho phần mô tả công việc (job description) được load
    await page.waitForSelector('[data-test*="job-description"]', { timeout: 60000 });

    // Lấy thông tin chi tiết của công việc
    const jobDetails = await page.evaluate(() => {
        const title = document.querySelector('[data-test*="job-title-title-link"]')?.innerText.trim() || '';
        const description = document.querySelector('[data-test*="job-description"]')?.innerText.trim() || '';
        const rate = document.querySelector('[data-test*="job-tile-rate"]')?.innerText.trim() || '';
        const duration = document.querySelector('[data-test*="job-tile-duration"]')?.innerText.trim() || '';
        const experience = document.querySelector('[data-test*="job-tile-experience"]')?.innerText.trim() || '';
        const skills = Array.from(document.querySelectorAll('[data-test*="job-tile-skills"] span'))
                            .map(el => el.innerText.trim());
        return { title, description, rate, duration, experience, skills };
    });

    // Nếu có hàm extendOutputFunction được cung cấp từ input, gọi nó để mở rộng kết quả
    let userResult = {};
    if (extendOutputFunction) {
        userResult = await page.evaluate((functionStr) => {
            // eslint-disable-next-line no-eval
            const f = eval(functionStr);
            return f();
        }, extendOutputFunction);
    }

    // Kết hợp dữ liệu lấy được với kết quả từ extendOutputFunction (nếu có)
    const job = Object.assign({}, jobDetails, { jobUrl: request.url }, userResult);

    // Đẩy dữ liệu vào dataset nếu chưa vượt quá số lượng tối đa
    if (itemCount < maxItems) {
        await Apify.pushData(job);
    }
};
