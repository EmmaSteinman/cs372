B. 4.4BSD Scheduler
===================

The goal of a general-purpose scheduler is to balance threads' different scheduling needs. Threads that perform a lot of I/O require a fast response time to keep input and output devices busy, but need little CPU time. On the other hand, compute-bound threads need to receive a lot of CPU time to finish their work, but have no requirement for fast response time. Other threads lie somewhere in between, with periods of I/O punctuated by periods of computation, and thus have requirements that vary over time. A well-designed scheduler can often accommodate threads with all these requirements simultaneously.

For project 1, you must implement the scheduler described in this appendix. Our scheduler resembles the one described in \[ [McKusick](pintos_14.html#McKusick)\], which is one example of a _multilevel feedback queue_ scheduler. This type of scheduler maintains several queues of ready-to-run threads, where each queue holds threads with a different priority. At any given time, the scheduler chooses a thread from the highest-priority non-empty queue. If the highest-priority queue contains multiple threads, then they run in "round robin" order.

Multiple facets of the scheduler require data to be updated after a certain number of timer ticks. In every case, these updates should occur before any ordinary kernel thread has a chance to run, so that there is no chance that a kernel thread could see a newly increased `timer_ticks()` value but old scheduler data values.

The 4.4BSD scheduler does not include priority donation.

* * *

B.1 Niceness
------------

Thread priority is dynamically determined by the scheduler using a formula given below. However, each thread also has an integer _nice_ value that determines how "nice" the thread should be to other threads. A nice of zero does not affect thread priority. A positive nice, to the maximum of 20, decreases the priority of a thread and causes it to give up some CPU time it would otherwise receive. On the other hand, a negative nice, to the minimum of -20, tends to take away CPU time from other threads.

The initial thread starts with a nice value of zero. Other threads start with a nice value inherited from their parent thread. You must implement the functions described below, which are for use by test programs. We have provided skeleton definitions for them in threads/thread.c.

Function: int **thread\_get\_nice** (void)

Returns the current thread's nice value.

Function: void **thread\_set\_nice** (int new\_nice)

Sets the current thread's nice value to new\_nice and recalculates the thread's priority based on the new value (see section [B.2 Calculating Priority](pintos_8.html#SEC143)). If the running thread no longer has the highest priority, yields.

* * *

B.2 Calculating Priority
------------------------

Our scheduler has 64 priorities and thus 64 ready queues, numbered 0 (`PRI_MIN`) through 63 (`PRI_MAX`). Lower numbers correspond to lower priorities, so that priority 0 is the lowest priority and priority 63 is the highest. Thread priority is calculated initially at thread initialization. It is also recalculated once every fourth clock tick, for every thread. In either case, it is determined by the formula

priority = `PRI_MAX` - (recent\_cpu / 4) - (nice \* 2),

where recent\_cpu is an estimate of the CPU time the thread has used recently (see below) and nice is the thread's nice value. The result should be rounded down to the nearest integer (truncated). The coefficients 1/4 and 2 on recent\_cpu and nice, respectively, have been found to work well in practice but lack deeper meaning. The calculated priority is always adjusted to lie in the valid range `PRI_MIN` to `PRI_MAX`.

This formula gives a thread that has received CPU time recently lower priority for being reassigned the CPU the next time the scheduler runs. This is key to preventing starvation: a thread that has not received any CPU time recently will have a recent\_cpu of 0, which barring a high nice value should ensure that it receives CPU time soon.

* * *

B.3 Calculating recent\_cpu
---------------------------

We wish recent\_cpu to measure how much CPU time each process has received "recently." Furthermore, as a refinement, more recent CPU time should be weighted more heavily than less recent CPU time. One approach would use an array of n elements to track the CPU time received in each of the last n seconds. However, this approach requires O(n) space per thread and O(n) time per calculation of a new weighted average.

Instead, we use a _exponentially weighted moving average_, which takes this general form:

x(0) = f(0),

x(t) = a\*x(t-1) + f(t),

a = k/(k+1),

where x(t) is the moving average at integer time t >= 0, f(t) is the function being averaged, and k > 0 controls the rate of decay. We can iterate the formula over a few steps as follows:

x(1) = f(1),

x(2) = a\*f(1) + f(2),

...

x(5) = a\*\*4\*f(1) + a\*\*3\*f(2) + a\*\*2\*f(3) + a\*f(4) + f(5).

The value of f(t) has a weight of 1 at time t, a weight of a at time t+1, a\*\*2 at time t+2, and so on. We can also relate x(t) to k: f(t) has a weight of approximately 1/e at time t+k, approximately 1/e\*\*2 at time t+2\*k, and so on. From the opposite direction, f(t) decays to weight w at time t + ln(w)/ln(a).

The initial value of recent\_cpu is 0 in the first thread created, or the parent's value in other new threads. Each time a timer interrupt occurs, recent\_cpu is incremented by 1 for the running thread only, unless the idle thread is running. In addition, once per second the value of recent\_cpu is recalculated for every thread (whether running, ready, or blocked), using this formula:

recent\_cpu = (2\*load\_avg)/(2\*load\_avg + 1) \* recent\_cpu + nice,

where load\_avg is a moving average of the number of threads ready to run (see below). If load\_avg is 1, indicating that a single thread, on average, is competing for the CPU, then the current value of recent\_cpu decays to a weight of .1 in ln(.1)/ln(2/3) = approx. 6 seconds; if load\_avg is 2, then decay to a weight of .1 takes ln(.1)/ln(3/4) = approx. 8 seconds. The effect is that recent\_cpu estimates the amount of CPU time the thread has received "recently," with the rate of decay inversely proportional to the number of threads competing for the CPU.

Assumptions made by some of the tests require that these recalculations of recent\_cpu be made exactly when the system tick counter reaches a multiple of a second, that is, when `timer_ticks () % TIMER_FREQ == 0`, and not at any other time.

The value of recent\_cpu can be negative for a thread with a negative nice value. Do not clamp negative recent\_cpu to 0.

You may need to think about the order of calculations in this formula. We recommend computing the coefficient of recent\_cpu first, then multiplying. Some students have reported that multiplying load\_avg by recent\_cpu directly can cause overflow.

You must implement `thread_get_recent_cpu()`, for which there is a skeleton in threads/thread.c.

Function: int **thread\_get\_recent\_cpu** (void)

Returns 100 times the current thread's recent\_cpu value, rounded to the nearest integer.

* * *

B.4 Calculating load\_avg
-------------------------

Finally, load\_avg, often known as the system load average, estimates the average number of threads ready to run over the past minute. Like recent\_cpu, it is an exponentially weighted moving average. Unlike priority and recent\_cpu, load\_avg is system-wide, not thread-specific. At system boot, it is initialized to 0. Once per second thereafter, it is updated according to the following formula:

load\_avg = (59/60)\*load\_avg + (1/60)\*ready\_threads,

where ready\_threads is the number of threads that are either running or ready to run at time of update (not including the idle thread).

Because of assumptions made by some of the tests, load\_avg must be updated exactly when the system tick counter reaches a multiple of a second, that is, when `timer_ticks () % TIMER_FREQ == 0`, and not at any other time.

You must implement `thread_get_load_avg()`, for which there is a skeleton in threads/thread.c.

Function: int **thread\_get\_load\_avg** (void)

Returns 100 times the current system load average, rounded to the nearest integer.

* * *

B.5 Summary
-----------

The following formulas summarize the calculations required to implement the scheduler. They are not a complete description of scheduler requirements.

Every thread has a nice value between -20 and 20 directly under its control. Each thread also has a priority, between 0 (`PRI_MIN`) through 63 (`PRI_MAX`), which is recalculated using the following formula every fourth tick:

priority = `PRI_MAX` - (recent\_cpu / 4) - (nice \* 2).

recent\_cpu measures the amount of CPU time a thread has received "recently." On each timer tick, the running thread's recent\_cpu is incremented by 1. Once per second, every thread's recent\_cpu is updated this way:

recent\_cpu = (2\*load\_avg)/(2\*load\_avg + 1) \* recent\_cpu + nice.

load\_avg estimates the average number of threads ready to run over the past minute. It is initialized to 0 at boot and recalculated once per second as follows:

load\_avg = (59/60)\*load\_avg + (1/60)\*ready\_threads.

where ready\_threads is the number of threads that are either running or ready to run at time of update (not including the idle thread).

* * *

B.6 Fixed-Point Real Arithmetic
-------------------------------

In the formulas above, priority, nice, and ready\_threads are integers, but recent\_cpu and load\_avg are real numbers. Unfortunately, Pintos does not support floating-point arithmetic in the kernel, because it would complicate and slow the kernel. Real kernels often have the same limitation, for the same reason. This means that calculations on real quantities must be simulated using integers. This is not difficult, but many students do not know how to do it. This section explains the basics.

The fundamental idea is to treat the rightmost bits of an integer as representing a fraction. For example, we can designate the lowest 14 bits of a signed 32-bit integer as fractional bits, so that an integer x represents the real number x/(2\*\*14), where \*\* represents exponentiation. This is called a 17.14 fixed-point number representation, because there are 17 bits before the decimal point, 14 bits after it, and one sign bit.[(6)](pintos_fot.html#FOOT6) A number in 17.14 format represents, at maximum, a value of (2\*\*31 - 1)/(2\*\*14) = approx. 131,071.999.

Suppose that we are using a p.q fixed-point format, and let f = 2\*\*q. By the definition above, we can convert an integer or real number into p.q format by multiplying with f. For example, in 17.14 format the fraction 59/60 used in the calculation of load\_avg, above, is 59/60\*(2\*\*14) = 16,110. To convert a fixed-point value back to an integer, divide by f. (The normal / operator in C rounds toward zero, that is, it rounds positive numbers down and negative numbers up. To round to nearest, add f / 2 to a positive number, or subtract it from a negative number, before dividing.)

Many operations on fixed-point numbers are straightforward. Let `x` and `y` be fixed-point numbers, and let `n` be an integer. Then the sum of `x` and `y` is `x + y` and their difference is `x - y`. The sum of `x` and `n` is `x + n * f`; difference, `x - n * f`; product, `x * n`; quotient, `x / n`.

Multiplying two fixed-point values has two complications. First, the decimal point of the result is q bits too far to the left. Consider that (59/60)\*(59/60) should be slightly less than 1, but 16,111\*16,111 = 259,564,321 is much greater than 2\*\*14 = 16,384. Shifting q bits right, we get 259,564,321/(2\*\*14) = 15,842, or about 0.97, the correct answer. Second, the multiplication can overflow even though the answer is representable. For example, 64 in 17.14 format is 64\*(2\*\*14) = 1,048,576 and its square 64\*\*2 = 4,096 is well within the 17.14 range, but 1,048,576\*\*2 = 2\*\*40, greater than the maximum signed 32-bit integer value 2\*\*31 - 1. An easy solution is to do the multiplication as a 64-bit operation. The product of `x` and `y` is then `((int64_t) x) * y / f`.

Dividing two fixed-point values has opposite issues. The decimal point will be too far to the right, which we fix by shifting the dividend q bits to the left before the division. The left shift discards the top q bits of the dividend, which we can again fix by doing the division in 64 bits. Thus, the quotient when `x` is divided by `y` is `((int64_t) x) * f / y`.

This section has consistently used multiplication or division by f, instead of q-bit shifts, for two reasons. First, multiplication and division do not have the surprising operator precedence of the C shift operators. Second, multiplication and division are well-defined on negative operands, but the C shift operators are not. Take care with these issues in your implementation.

The following table summarizes how fixed-point arithmetic operations can be implemented in C. In the table, `x` and `y` are fixed-point numbers, `n` is an integer, fixed-point numbers are in signed p.q format where p + q = 31, and `f` is `1 << q`:

Convert `n` to fixed point:

`n * f`

Convert `x` to integer (rounding toward zero):

`x / f`

Convert `x` to integer (rounding to nearest):

`(x + f / 2) / f` if `x >= 0`,
`(x - f / 2) / f` if `x <= 0`.

Add `x` and `y`:

`x + y`

Subtract `y` from `x`:

`x - y`

Add `x` and `n`:

`x + n * f`

Subtract `n` from `x`:

`x - n * f`

Multiply `x` by `y`:

`((int64_t) x) * y / f`

Multiply `x` by `n`:

`x * n`

Divide `x` by `y`:

`((int64_t) x) * f / y`

Divide `x` by `n`:

`x / n`

* * *
