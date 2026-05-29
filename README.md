# ⚡ SQL Query Optimization — Case Studies

## Overview
5 real-world SQL performance problems — each with a bad query,
optimized query, EXPLAIN analysis, and the lesson behind it.

## Environment
- MySQL 8.0
- MySQL Workbench
- Dataset: 10,000 orders, 10,000 items, 500 employees (synthetic)

## Case Studies

| # | Problem | Solution | Key Concept |
|---|---|---|---|
| 1 | Function on indexed column | Range condition | Index awareness |
| 2 | SELECT * on large JOIN | Select specific columns | Memory efficiency |
| 3 | Correlated subquery | JOIN + GROUP BY | O(n²) → O(n) |
| 4 | IN vs EXISTS | EXISTS clause | Short-circuit evaluation |
| 5 | Repeated subqueries | CTE | Compute once, reuse |

## How to Read EXPLAIN Output
| type value | Meaning |
|---|---|
| ALL | Full table scan — worst case |
| index | Full index scan |
| range | Index range scan — good |
| ref | Index lookup — good |
| const | Single row lookup — best |

## Golden Rules of SQL Optimization
1. Never wrap indexed columns in functions
2. Always SELECT only columns you need
3. Replace correlated subqueries with JOINs
4. Use EXISTS over IN for large subquery results
5. Use CTEs to avoid repeating subexpressions
