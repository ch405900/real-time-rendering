import { defineConfig } from 'vitepress'
import mathjax3 from 'markdown-it-mathjax3';

// https://vitepress.dev/reference/site-config
export default defineConfig({
	base: "/real-time-rendering/",
	title: "Real Time Rendering",
	description: "Real Time Rendering Playground",
	themeConfig: {
		// https://vitepress.dev/reference/default-theme-config
		nav: [
			{ text: 'Home', link: '/' },
			{ text: 'Contents', link: '/chapter5' }
		],

		sidebar: [
			{
				text: 'Contents',
				items: [
					{ text: 'Shading Basics 着色基础', link: '/chapter5' },
					{ text: 'Texturing 纹理', link: '/chapter6' }
				]
			}
		],

		socialLinks: [
			{ icon: 'github', link: 'https://github.com/vuejs/vitepress' }
		]
	},
	vite: {
		assetsInclude: ['**/*.glsl','**/*.exr'], // 允许导入 .glsl 文件
	},
	markdown: {
		config: (md) => {
			md.use(mathjax3);
		},
	},
})
