// copy to ktx/src
// cc rng.c rng_gen_impl.c rng_seed_impl.c rng_test.c -rng_test c -I ../include

#include <stdio.h>
#include <stdlib.h>

#include "rng.h"

void g_random_seed(int seed)
{
        rng_seed_global(seed);
}

float g_random(void)
{
        return (rng_next_global() >> 8 & 0xffffff) / 16777216.0f;
}

float bound(float a, float b, float c)
{
        return ((a >= c) ? a : (b < a) ? a : (b > c) ? c : b);
}

int i_rnd(int from, int to)
{
        float r;

        if (from >= to)
        {
                return from;
        }

	r = (int)(from + (1.0 + to - from) * g_random());

        return bound(from, r, to);
}

int main(int argc, char *argv[]) {
	int seed, iterations, curr, prev = -1, count = 0;

	if (argc != 3) {
		printf("usage: %s <seed> <iterations>\n", argv[0]);
		return 0;
	}

	seed = atoi(argv[1]);
	iterations = atoi(argv[2]);

	g_random_seed(seed);

	for (int i = 0; i < iterations; i++)
	{
		curr = i_rnd(0,  5);

		if (curr == prev)
                        count++;
                else
                {
                        if (count > 0)
                                printf("repeated %d\n", count + 1);

                        count = 0;
                }

                prev = curr;
	}

	if (count > 0)
		printf("repeated %d\n", count + 1);

	return 0;
}
