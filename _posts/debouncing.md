While I was working with embedded systems, the issue of button debouncing in software came up regularly. Dealing with the issue in software is often cheaper to produce and faster to iterate on. Button debouncing is not a particularly hard problem, but most of the resources I've seen just send readers on their way with a few examples. Understanding the theory underneath the solutions is critical to implementing an optimal solution.

In this post I will look at some theory then examine a few approaches based on their reliability, overhead, and response time.

# General Theory

__PROBLEM:__ Input devices are physical/analog components and will *bounce*
between states during a state change causing inputs to be misinterpreted.

This bouncing is a result of:

- capacitance causing the signal to linger in a meta-stable state (midway between logical 0 and 1) [][]

- physical characteristics of the button causing contacts to rebound [][]

These behaviors depend on so many variables that it's infeasible to accurately model input bounce. As a result, processing input signals will always have latency. 

Fortunately--much like we pretend analog signals are either on or off--we can set up an abstraction model to make handling bounce easier. The only contracts needed for such a model are:

- `input width` -- the minimum period an input must remain in a state in order to be recognized

- `input latency` -- the maximum amount of time between an input's state changing and the software seeing said change

The goal is to minimize both input width and latency while __never__ misinterpreting an input due to bounce. [][] Using a significant computational overhead is also undesirable.

## Sampling Theory

At some point, whether it's by a hardware interrupt or software, the all processor input is going to be polled. [][] So understanding issues related to polling is absolutely necessary while writing any sort of physical facing code, debouncing or otherwise.

When polling analog signals the digital world, the most powerful tool is the `Cardinal Theorem of Interpolation` (aka Nyquist's Theorem). [][] The theorem roughly states:

> If a signal has a maximum frequency of X hertz, it can be completely determined by sampling every 1 / (2 * X) seconds.

So if you're polling at 16 mhz you can accurately detect any signals < 8 mhz, or input widths longer than 12.5 ns.

As stated in the previous section, the bounce signal/frequency cannot be accurately modeled, so it's not as simple as invoking Nyquist and calling it a day. In order to handle this we need to define `bounce period`.

## Bounce Period

__definition:__ the maximum amount of time an input is unstable after a state change

Inside the bounce period, there is no guarantee that the `Cardinal Theorem of Interpolation` can be applied. Meaning for the bounce period:

- The current state between samples cannot be known.

- The exact time of the state change cannot be known.

The above image illustrates a worst case scenario.

With the above limitations in mind, two useful assertions can be made:

__1:__

> Given a signal where the only noise is due to bounce and the same state has been sampled over a period longer than the debounce period, the state can be assumed to be stable.

This assertion holds because:

- one or more of the samples must be from outside the bounce period

- the value of the stable sample is known (because they're all the same)

_input width:_ -- The input width of this assertion is the bounce period +
the sample period

_input latency:_ -- The input latency of this assertion has a best and worse
case equal to the bounce period + the sample period

__2:__ 

> Given a signal where the only noise is due to bounce and a stable state, if the opposite state is sampled we know we are at some point in the debounce period.

This assertion holds because the only way a state can change is by 

_input width:_ -- The input width of this assertion is twice the bounce period

_input latency:_ -- The input latency of this assertion has a best case of
~instant, a worst case of the bounce period, and an average that 

# Physical Implementation



# Footnotes

[]: https://ptolemy.eecs.berkeley.edu/eecs20/week13/nyquistShannon.html
