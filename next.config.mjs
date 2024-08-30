/** @type {import('next').NextConfig} */

const nextConfig = {
    experimental: {
        ppr: 'incremental'  // 增加这个配置，咱们路由就可以使用ppr
    }
};

export default nextConfig;
