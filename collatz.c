#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include <stdbool.h>
#include <sys/sysinfo.h>
#include <pthread.h>
#include <unistd.h>
#include <errno.h>

static void collatz(uint64_t val, uint64_t* seq_len, uint64_t* max_height);
static void collatz_print(uint64_t val);
static void* collatz_thread();

static bool sync_max(uint64_t* variable, uint64_t new_value);

static uint64_t synced_start = 1;

static uint64_t max_len = 0;
static uint64_t max_height = 0;



static uint64_t thread_count;

// main method
int main(int args_len, char** args)
{
	// single chain mode
	if (args_len == 2)
	{
		char* eptr;
		uint64_t start = strtoll(args[1], &eptr, 10); // read long long
		if (start > 0)
		{
			if (errno == EINVAL)
			{
				printf("Error: long value out of bounds!\n");
				return 1;
			}
			collatz_print(start);
			return 0;
		}
	}

	// extremum seeking mode (threads)
	thread_count = get_nprocs(); 
	printf("Detected %" PRIu64 " processor cores...\n\n", thread_count);
	sleep(2);

	for (uint64_t i = 0; i < thread_count - 1; i++)
	{
		pthread_t tid;
		pthread_create(&tid, NULL, collatz_thread, NULL);
	}

	collatz_thread();

}

// atomically updates the pointed to value to maximum of old and new value
bool sync_max(uint64_t* ptr, uint64_t new_val)
{
	uint64_t old_val;
	bool bigger;

	do
	{
		old_val = *ptr;
		bigger = old_val < new_val;
	} while (bigger && !__sync_val_compare_and_swap(ptr, old_val, new_val));

	return bigger;
}

void* collatz_thread()
{
	uint64_t len;
        uint64_t height;

	while (true)
        {
		uint64_t start = __sync_fetch_and_add(&synced_start, 1);
                collatz(start, &len, &height);

                if (sync_max(&max_len, len))
                {
                        printf("New Maximum Sequence Length: %" PRIu64 ", starting from %" PRIu64 " (up to %" PRIu64 ")\n", len, start, height);
                }
                if (sync_max(&max_height, height))
		{
                        printf("New Maximum Height: %" PRIu64 ". (reached from start point %" PRIu64 ")\n", height, start);
                }
        }

}

void collatz(uint64_t val, uint64_t* seq_len, uint64_t* max_height)
{
	*seq_len = 1;
	*max_height = 0;

	while (val > 1)
	{
		*seq_len = *seq_len + 1;

		uint32_t isOdd = val % 2; // 1 (true) if is odd, 0 (false) if even 
		uint32_t isEven = 1 - isOdd; // 1 (true) if even, 0 (false) if odd

		// branchless collatz implementation -> divide by 2 if even, multiple by 3 and add 1 otherwise
		uint64_t odd_val = val + val + val + 1;
		uint64_t even_val = val / 2;
		val = odd_val * (isOdd) + even_val * (isEven);

		// max
		if (*max_height < val)
		{
			*max_height = val;
		}
	}

}

void collatz_print(uint64_t val)
{
	uint64_t max = 1;
	uint64_t len = 1;

	printf("%" PRIu64 "\n", val);
	while (val > 1)
        {
                uint32_t isOdd = val % 2; // 1 (true) if is odd, 0 (false) if even
                uint32_t isEven = 1 - isOdd; // 1 (true) if even, 0 (false) if odd

                // branchless collatz implementation -> divide by 2 if even, multiple by 3 and add 1 otherwise
                uint64_t odd_val = 3 * val + 1;
                uint64_t even_val = val / 2;
                val = odd_val * (isOdd) + even_val * (isEven);

		printf("%" PRIu64 "\n", val);
		
		if (val > max)
			max = val;
		len++;
	}

	printf("======================================================\n");
	printf("sequence length:\t%" PRIu64 "\n", len);
	printf("sequence maximum:\t%" PRIu64 "\n", max);
}
