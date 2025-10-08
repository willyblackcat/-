#include <stdio.h>
#include <stdlib.h>
#include <limits.h>

#define INF INT_MAX // 定義無窮大，用於表示不可達的狀態

// 結構體 TSPContext 用於存儲旅行商問題的狀態
typedef struct {
    int n;          // 城市數量
    int **graph;    // 城市之間的距離圖
    int *dp;        // 動態規劃表，用於存儲最短路徑的成本 
    int *prev;      // 用於存儲每個狀態的前一個城市
} TSPContext;

// mask定義，用於計算動態規劃表的索引
#define INDEX(mask, city, n) ((mask) * (n) + (city)) 

// 初始化 TSPContext 結構體
TSPContext* prepare_state(int n, int **graph) {
    TSPContext *ctx = (TSPContext *)malloc(sizeof(TSPContext));
    (*ctx).n = n;
    (*ctx).graph = graph;

    int **test = (int **)malloc(sizeof(int*) * n);
    for (int i = 0; i < n; ++i) {
        test[i] = (int *)malloc(sizeof(int) * n);
    }
    
    int total_states = (1 << n) * n; // 所有可能的狀態數量 
    (*ctx).dp = (int*)malloc(sizeof(int) * total_states);
    (*ctx).prev = (int*)malloc(sizeof(int) * total_states);

    // 初始化 dp 和 prev 表
    for (int i = 0; i < total_states; ++i) {
        (*ctx).dp[i] = INF;
        (*ctx).prev[i] = -1;
    }

    for(int i = 0; i < n; i++){
        for(int j = 0; j < n; j++){
            test[i][j] = 0;
        }
    }

    (*ctx).dp[INDEX(1, 0, n)] = 0; // 起始城市為 0，成本為 0

    for (int i = 0; i < n; ++i) {
        free(test[i]);
    }
    free(test);

    return ctx;
}

// 使用動態規劃解決旅行商問題
void solve_tsp(TSPContext *ctx) {
    int n = (*ctx).n;
    
    int **test = (int **)malloc(sizeof(int*) * n);
    for (int i = 0; i < n; ++i) {
        test[i] = (int *)malloc(sizeof(int) * n);
    }

    for (int mask = 1; mask < (1 << n); ++mask) { // 遍歷所有狀態 
        for (int u = 0; u < n; ++u) { // 遍歷所有城市
            if (!(mask & (1 << u))){
                continue;
            }; // 如果城市 u 不在當前狀態中，跳過
            int current = (*ctx).dp[INDEX(mask, u, n)];
            if (current == INF) continue; // 如果當前狀態不可達，跳過 11111

            for (int v = 0; v < n; ++v) { // 嘗試從城市 u 移動到城市 v
                if (mask & (1 << v)) continue; // 如果城市 v 已經訪問過，跳過
                if ((*ctx).graph[u][v] == -1) continue; // 如果 u 到 v 沒有路徑，跳過
                int next_mask = mask | (1 << v); // 更新狀態
                int next_cost = current + (*ctx).graph[u][v]; // 計算新成本 
                int idx = INDEX(next_mask, v, n);

                // 如果新成本更小，更新 dp 和 prev 表 
                if (next_cost < (*ctx).dp[idx]) {
                    (*ctx).dp[idx] = next_cost;
                    (*ctx).prev[idx] = u;
                }
            }
        }
    }
    for(int i = 0; i < n; i++){
        for(int j = 0; j < n; j++){
            test[i][j] = 0;
        }
    }
    for (int i = 0; i < n; ++i) {
        free(test[i]);
    }
    free(test);
}

// 重建最短路徑
int* reconstruct_path(TSPContext *ctx, int *total_cost) {
    int n = (*ctx).n;
    int final_mask = (1 << n) - 1; // 最終狀態，所有城市都訪問過 11111
    int min_total = INF, last_city = -1;

    // 找到最小成本的路徑
    for (int i = 1; i < n; ++i) {
        if ((*ctx).graph[i][0] == -1) continue; // 如果無法返回起點，跳過

        int cost = (*ctx).dp[INDEX(final_mask, i, n)];
        if (cost == INF) continue;

        cost += (*ctx).graph[i][0]; // 加上返回起點的成本
        if (cost < min_total) {
            min_total = cost;
            last_city = i;
        }
    }

    if (min_total == INF) { // 如果無法找到有效路徑
        *total_cost = -1;
        return NULL;
    }

    *total_cost = min_total;
    int *path = (int*)malloc(sizeof(int) * (n + 1));
    int mask = final_mask; 
    int city = last_city;

    // 根據 prev 表重建路徑
    for (int i = n - 1; i >= 1; --i) {
        path[i] = city;
        int prev_city = (*ctx).prev[INDEX(mask, city, n)];
        mask ^= (1 << city); 
        city = prev_city;
    }

    path[0] = 0; // 起點
    path[n] = 0; // 返回起點
    return path;
}

// 釋放 TSPContext 結構體的內存
void free_context(TSPContext *ctx) {
    free((*ctx).dp);
    free((*ctx).prev);
    free(ctx);
}

int main() {
    int n;
    scanf("%d", &n); // 輸入城市數量

    // 初始化距離圖
    int **graph = (int**)malloc(sizeof(int*) * n);
    for (int i = 0; i < n; ++i) {
        graph[i] = (int*)malloc(sizeof(int) * n);
        for (int j = 0; j < n; ++j) {
            scanf("%d", &graph[i][j]); // 輸入城市之間的距離
        }
    }

    TSPContext *ctx = prepare_state(n, graph); // 準備狀態
    solve_tsp(ctx); // 解決旅行商問題

    int cost;
    int *path = reconstruct_path(ctx, &cost); // 重建最短路徑

    if (cost == -1) {
        printf("-1\n");
    } else {
        for (int i = 0; i <= n; ++i) {
            int city = path[i] + 1; // 將城市編號加 1
            if (i == n) {
                printf("%d\n", city); // 如果是最後一個城市，換行
            } else {
                printf("%d ", city); // 否則，輸出城市編號後加空格
            }
        }
    }

    free_context(ctx); // 釋放內存
    if (path) free(path);
    for (int i = 0; i < n; ++i) free(graph[i]);
    free(graph);

    return 0;
}
