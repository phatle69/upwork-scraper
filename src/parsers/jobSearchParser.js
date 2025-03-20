const Apify = require('apify');
const { log } = require('../tools');

exports.jobSearchParser = async ({ requestQueue, page }) => {
    log.debug('Processing job search URL...');

    // Chờ phần container chứa danh sách job được load
    await page.waitForSelector('[data-test="job-tile-list"]', { timeout: 60000 });

    // Lấy danh sách các job từ trang tìm kiếm
    const jobs = await page.$$eval('[data-test*="job-tile"]', ($jobNodes) => {
        return $jobNodes.map((job) => {
            const title = job.querySelector('[data-test*="job-title-title-link"]')?.innerText.trim() || '';
            const snippet = job.querySelector('[data-test*="job-tile-snippet"]')?.innerText.trim() || '';
            const rate = job.querySelector('[data-test*="job-tile-rate"]')?.innerText.trim() || '';
            const duration = job.querySelector('[data-test*="job-tile-duration"]')?.innerText.trim() || '';
            const experience = job.querySelector('[data-test*="job-tile-experience"]')?.innerText.trim() || '';
            const skills = Array.from(job.querySelectorAll('[data-test*="job-tile-skills"] span'))
                                .map((el) => el.innerText.trim());
            return { title, snippet, rate, duration, experience, skills };
        });
    });

    // Nếu tìm thấy dữ liệu job thì đẩy dữ liệu ra dataset
    if (jobs && jobs.length > 0) {
        await Apify.pushData(jobs);
    }

    // Nếu có logic phân trang (next page), bạn có thể gọi hàm goToNextPage tương tự như trong profileSearchParser
    // Ví dụ:
    // await goToNextPage({ requestQueue, page });
};
