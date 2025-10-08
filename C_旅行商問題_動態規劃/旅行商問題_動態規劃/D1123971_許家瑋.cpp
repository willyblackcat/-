#include <stdio.h>
#include <stdlib.h>
#include <limits.h>

#define INF INT_MAX // �w�q�L�a�j�A�Ω��ܤ��i�F�����A

// ���c�� TSPContext �Ω�s�x�Ȧ�Ӱ��D�����A
typedef struct {
    int n;          // �����ƶq
    int **graph;    // �����������Z����
    int *dp;        // �ʺA�W����A�Ω�s�x�̵u���|������ 
    int *prev;      // �Ω�s�x�C�Ӫ��A���e�@�ӫ���
} TSPContext;

// mask�w�q�A�Ω�p��ʺA�W��������
#define INDEX(mask, city, n) ((mask) * (n) + (city)) 

// ��l�� TSPContext ���c��
TSPContext* prepare_state(int n, int **graph) {
    TSPContext *ctx = (TSPContext *)malloc(sizeof(TSPContext));
    (*ctx).n = n;
    (*ctx).graph = graph;

    int **test = (int **)malloc(sizeof(int*) * n);
    for (int i = 0; i < n; ++i) {
        test[i] = (int *)malloc(sizeof(int) * n);
    }
    
    int total_states = (1 << n) * n; // �Ҧ��i�઺���A�ƶq 
    (*ctx).dp = (int*)malloc(sizeof(int) * total_states);
    (*ctx).prev = (int*)malloc(sizeof(int) * total_states);

    // ��l�� dp �M prev ��
    for (int i = 0; i < total_states; ++i) {
        (*ctx).dp[i] = INF;
        (*ctx).prev[i] = -1;
    }

    for(int i = 0; i < n; i++){
        for(int j = 0; j < n; j++){
            test[i][j] = 0;
        }
    }

    (*ctx).dp[INDEX(1, 0, n)] = 0; // �_�l������ 0�A������ 0

    for (int i = 0; i < n; ++i) {
        free(test[i]);
    }
    free(test);

    return ctx;
}

// �ϥΰʺA�W���ѨM�Ȧ�Ӱ��D
void solve_tsp(TSPContext *ctx) {
    int n = (*ctx).n;
    
    int **test = (int **)malloc(sizeof(int*) * n);
    for (int i = 0; i < n; ++i) {
        test[i] = (int *)malloc(sizeof(int) * n);
    }

    for (int mask = 1; mask < (1 << n); ++mask) { // �M���Ҧ����A 
        for (int u = 0; u < n; ++u) { // �M���Ҧ�����
            if (!(mask & (1 << u))){
                continue;
            }; // �p�G���� u ���b��e���A���A���L
            int current = (*ctx).dp[INDEX(mask, u, n)];
            if (current == INF) continue; // �p�G��e���A���i�F�A���L 11111

            for (int v = 0; v < n; ++v) { // ���ձq���� u ���ʨ쫰�� v
                if (mask & (1 << v)) continue; // �p�G���� v �w�g�X�ݹL�A���L
                if ((*ctx).graph[u][v] == -1) continue; // �p�G u �� v �S�����|�A���L
                int next_mask = mask | (1 << v); // ��s���A
                int next_cost = current + (*ctx).graph[u][v]; // �p��s���� 
                int idx = INDEX(next_mask, v, n);

                // �p�G�s������p�A��s dp �M prev �� 
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

// ���س̵u���|
int* reconstruct_path(TSPContext *ctx, int *total_cost) {
    int n = (*ctx).n;
    int final_mask = (1 << n) - 1; // �̲ת��A�A�Ҧ��������X�ݹL 11111
    int min_total = INF, last_city = -1;

    // ���̤p���������|
    for (int i = 1; i < n; ++i) {
        if ((*ctx).graph[i][0] == -1) continue; // �p�G�L�k��^�_�I�A���L

        int cost = (*ctx).dp[INDEX(final_mask, i, n)];
        if (cost == INF) continue;

        cost += (*ctx).graph[i][0]; // �[�W��^�_�I������
        if (cost < min_total) {
            min_total = cost;
            last_city = i;
        }
    }

    if (min_total == INF) { // �p�G�L�k��즳�ĸ��|
        *total_cost = -1;
        return NULL;
    }

    *total_cost = min_total;
    int *path = (int*)malloc(sizeof(int) * (n + 1));
    int mask = final_mask; 
    int city = last_city;

    // �ھ� prev ���ظ��|
    for (int i = n - 1; i >= 1; --i) {
        path[i] = city;
        int prev_city = (*ctx).prev[INDEX(mask, city, n)];
        mask ^= (1 << city); 
        city = prev_city;
    }

    path[0] = 0; // �_�I
    path[n] = 0; // ��^�_�I
    return path;
}

// ���� TSPContext ���c�骺���s
void free_context(TSPContext *ctx) {
    free((*ctx).dp);
    free((*ctx).prev);
    free(ctx);
}

int main() {
    int n;
    scanf("%d", &n); // ��J�����ƶq

    // ��l�ƶZ����
    int **graph = (int**)malloc(sizeof(int*) * n);
    for (int i = 0; i < n; ++i) {
        graph[i] = (int*)malloc(sizeof(int) * n);
        for (int j = 0; j < n; ++j) {
            scanf("%d", &graph[i][j]); // ��J�����������Z��
        }
    }

    TSPContext *ctx = prepare_state(n, graph); // �ǳƪ��A
    solve_tsp(ctx); // �ѨM�Ȧ�Ӱ��D

    int cost;
    int *path = reconstruct_path(ctx, &cost); // ���س̵u���|

    if (cost == -1) {
        printf("-1\n");
    } else {
        for (int i = 0; i <= n; ++i) {
            int city = path[i] + 1; // �N�����s���[ 1
            if (i == n) {
                printf("%d\n", city); // �p�G�O�̫�@�ӫ����A����
            } else {
                printf("%d ", city); // �_�h�A��X�����s����[�Ů�
            }
        }
    }

    free_context(ctx); // ���񤺦s
    if (path) free(path);
    for (int i = 0; i < n; ++i) free(graph[i]);
    free(graph);

    return 0;
}
