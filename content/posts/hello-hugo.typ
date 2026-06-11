#import "@hugo/templates:0.1.0": article
#import "@hugo/utils:0.1.0": *

#show: article.with(
  title: "Hello, World!",
  date: datetime(year: 2022, month: 7, day: 30),
  weight: 0,
  tags: (
    category: "漫谈"
  ),
  draft: false,
  references: ```yml
  typst-and-hugo:
    type: Blog
    title: "Typst and Hugo"
    author: George Honeywood
    date: 2023
    url:
      value: https://george.honeywood.org.uk/blog/typst-and-hugo/
  ```,
)

= 前言

你好！我正在尝试使用 Typst 构建博客！

感谢 George Honeywood @typst-and-hugo 的分享和室友 #link("https://github.com/Vertsineu","@Vertsineu") 的帮助\~

#figure(
  caption: "你好，世界！",
  image("/images/hello-hugo/helloworld.jpg"),
) <fig-maomao>

本页面实际构建日期为 2026 年 5 月 11 日，为了同步一些早期的文章同时保持次序，将本文章的发布日期设置在了一个有意义的日子。