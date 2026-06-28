#import "@hugo/templates:0.1.0": article
#import "@hugo/utils:0.1.0": *

#show: article.with(
  title: "大数据算法 课程总结笔记 II（期中部分）",
  date: datetime(year: 2026, month: 6, day: 26),
  weight: 0,
  tags: (
    category: ("TCS", "数学", "课程笔记")
  ),
  draft: false,
  references: ```bib
@misc{bigdataalg_note,
  title        = {大数据算法讲义},
  author       = {丁虎},
  year         = {2026},
  url          = {https://hu-ding.github.io/data_pdf/2026/Big_Data_Alg_Draft.pdf}
}
  ```,
)

= 1 概率不等式
= 2 随机算法
= 3 降维
= 4 近邻查询
= 5 次线性算法