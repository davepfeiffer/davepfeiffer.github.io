

After encountering a problem that required debouncing micro-controller inputs and perusing the internet, I found a ridiculous amount of proposed solutions and no theory to support their effectiveness. Many of these solutions were also blatantly awful. Button debouncing is not a particularly difficult problem so I imagine most of these solutions are "good enough" in practice, but that is a horrible, terrifying way to develop technology.

In this post I will cover some theory then examine a few approaches and rate them based on their integrity, overhead, and response time.

__IMPORTANT NOTE:__ There is no such thing as one size fits all, but tailors don't start from the ground up when they make a suit. In order develop a sleek solution that will make the opposite sex swoon, the situation it will be used in and its measurements need to be considered.

# Theory

__PROBLEM:__ Physical inputs are asynchronous which may raise issues in synchronous micro-processors. 

Either the hardware is polling the input at its IO clock speed, or the software is polling the IO registers at an even slower speed.

Generally polling in software is absolutely flipping terrible and a huge waste of all resources except time spent reading a data sheet. Microprocessors have dedicated hardware polling each IO pin (faster than software can) regardless of whether they are used or not. The exception being if you're running some insanely time critical code and cannot:

- disable input interrupts while executing that code

- do said work in an interrupt with higher priority

__PROBLEM:__ Some input devices are junk and will "bounce" between states.
