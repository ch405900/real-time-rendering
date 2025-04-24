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
			{ text: 'Examples', link: '/markdown-examples' }
		],

		sidebar: [
			{
				text: 'Examples',
				items: [
					{ text: 'Markdown Examples', link: '/markdown-examples' },
					{ text: 'Shading Basics 着色基础', link: '/chapter5' }
				]
			}
		],

		socialLinks: [
			{ icon: 'github', link: 'https://github.com/vuejs/vitepress' }
		]
	},
	vite: {
		assetsInclude: ['**/*.glsl'], // 允许导入 .glsl 文件
	},
	markdown: {
		config: (md) => {
			md.use(mathjax3);
		},
	},
})
