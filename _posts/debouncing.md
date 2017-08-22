After working with embedded systems, talking with

In this post I will look at some theory then examine a few approaches and rate them based on their integrity, overhead, and response time.

# Theory

__PROBLEM:__ Input devices are physical components and will "bounce" between states during a state change causing inputs to be misinterpreted.

This bouncing is a result of: [1][1]

- capacitance (parasitic or otherwise) causing the signal to linger in a meta-stable state

- physical characteristics of the button causing contacts to rebound

These factors vary so much that it's infeasible to accurately model input bounce. As a result, processing input signals will always have latency. 

In order to 

- there is a frequency upper bound that any signal within is guaranteed to be recognized: `input width`

- there is a period after which an input is guaranteed to be responded to: `input delay`

The goal is to minimize both input width and delay while __never__ misinterpreting an input due to bounce. Using a significant computational overhead is also undesirable.

## Sampling Theory

At some point, whether it's by the hardware interrupt or software, the input is going to be polled.

When polling in analog signals the digital world, the most powerful tool is the "[cardinal theorem of interpolation](https://ptolemy.eecs.berkeley.edu/eecs20/week13/nyquistShannon.html)" (aka Nyquist's theorem). The theorem roughly states:

> If a signal has a maximum frequency of X hertz, it can be completely determined by sampling every 1 / (2 * X) seconds.

So if you're polling 16 mhz you can accurately detect any signals < 8 mhz, or inputs longer than 12.5 ns.

But input bounce raises a few problems:

- The bounce signal's frequency cannot be predetermined

- The bounce signal's frequency is likely faster than our processor can sample

So unfortunately all hopes of a concise and mathematically elegant solution go out the window here, but using some assumptions about the specific system the problem can still be workable.

## Bounce Period

__definition:__ the maximum amount of time an input is unstable after a state change

Inside the bounce period, there is no guarantee that the cardinal theorem of interpolation holds. Meaning for the debounce period:

- The sample period when it starts cannot be known

- The state between samples of the bounce period cannot be known

Not all hope is lost, there are a few assertions that can be helpful:

__1:__

> Given a signal where the only noise is due to input bounce and the same state has been sampled for a period longer than the debounce period, the state can be assumed to be stable.

This assertion holds because one or more of the samples must be from outside the bounce period and therefore stable.

__2:__ 

> Given a signal where the longest period of noise is due to input bounce and a stable state, if the opposite state is sampled we know we are at some point in the debounce period.

If a state is known to be stable then the only way it may change is by the input being toggled.

_note 1:_ If other noise sources exist, the problem becomes harder but may still be solvable. The details are out of scope for this post.

_note 2:_ If it can be determined that the bounce is within the Nyquist rate (maybe by adding capacitance to the input lines), more powerful assertions can be made. The assertions will likely take more computational resources to take advantage of, but also give faster response time and input rates.

_note 3:_ There are also lossy ways to process input signals, that may offer desirable trade-offs.

# Solutions

The two assertions from the theory section can be applied in many different ways to guarantee valid inputs with different trade-offs in:

- Processor time

- Input delay

- Input frequency

## Single input

```C



```
