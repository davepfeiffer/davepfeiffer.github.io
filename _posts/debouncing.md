
After encountering a problem that required debouncing micro-controller inputs and perusing the internet, I found a ridiculous amount of proposed solutions with no theory to support their effectiveness. Many of these solutions were also blatantly awful. Button debouncing is not a particularly difficult problem so I imagine most of these solutions are "good enough" in practice, but that is a scary way to develop technology.

In this post I will look at some theory then examine a few approaches and rate them based on their integrity, overhead, and response time.

__IMPORTANT NOTE:__ There is no such thing as one size fits all, but tailors don't start from the ground up when they make a suit. In order develop a sleek solution that will make the opposite sex swoon, the situation it will be used in and its measurements need to be considered.

# Theory -- Skip this if you're in a rush/lazy

__PROBLEM:__ Some input devices are junk and will "bounce" between states during a state change.

This bouncing is a result of:<sup id="">[]()</sup>

- capacitance (parasitic or otherwise) causing the signal to linger in a meta-stable state

- physical characteristics of the button causing contacts to be rebounded off

These factors vary so much that it's infeasible to model input bounce, so unfortunately every solution is going to be inherently flawed. In the digital world we normally get to pretend everything is perfect -- our work will never be frustrating and relationships always happy! Unfortunately the nastiness of input debouncing is the analog world breaching our abstraction defense and ruining our day.

As embedded/firmware engineers are the wardens of the digital world, it the responsibility of those writing low level software to shield the innocent from the horrors of analog design with sound abstraction models. In order to come up with a sound model the following assumptions need to be established:

- there is a pulse width that any pulse longer than is guaranteed to be recognized: `input width`

- there is a period after which an input is guaranteed to be responded to: `input delay`

The goals are to minimize both input width and delay while __never__ misinterpreting an input due to bounce. Misinterpreting input is failing the citizens of the digital world and exposing them to harsh realities. Using too much computational overhead is also criminal.

## Important Nuances to Keep in Mind

__1:__ Processors have a chance of not triggering an interrupt if the pulse is shorter than its IO clock period. 

The pulse width of debounce signals cannot be assumed, therefore the exact time of input cannot be assumed. The interrupt can be triggered at any point during the bounce time.

__2:__ No assumptions can be made about the number or frequency of logical 1s/0s in a bounce region.

## Input Width

__definition:__ the period

If the input is going to misbehave for a period of time after a state change, then it must be held longer than that period of time. Simple enough, but taking quirk #1 into account the state change cannot be known exactly:

![Input Width Example]({{ site.url }}/assets/debounce.jpg)

The processor's interrupt can be triggered at any point in the red region (the debounce time). The full debounce time always need to be ignored as there is no way to tell at what point in the bounce region the interrupt is triggered. This property causes the worst case input width to be twice the debounce time (shown by the purple).

Another issue is determining how long the input will misbehave for. As we established before, the bounce time is variable depending on circumstances that are hard to predict.

One approach is experimentation: 

- Assemble your system.

- Hook up an oscilloscope and mash the inputs a bunch of times at a bunch of different frequencies.

- Use some reasonable percentage more than the longest observed bounce time.

This should work well for existing hardware that can't be easily altered.

A second is to make some assumptions about a "reasonable" input and consider all inputs that don't behave in such a way to be broken. This method will work as long as the inputs in the final system are tested and ensured to be "reasonable". For consumer products this is a decent approach as it will allow for an enforced quality standard.

## Input Delay

__definition:__ the time between toggling an input and the processor handling the input

In a noise free environment where bounce is the only state instability, a nice assumption can be made to shorten input delay considerably:

`Assuming stability, if an edge is sensed, the input state can be updated instantly as bounce occurs only when a user is toggling the state.`

This assumption implies a best case delay of only a few clock cycles for the interrupt to handle the edge. The worst case delay would be the full bounce time where the input is sensed only when the signal stabilizes. The average case will trend towards the best case with higher polling frequency (CPU clock speed) and the the worst case the slower the polling.

# Solutions

There are two classes of handling inputs in microprocessors: software polling and interrupts

Both classes will be polling at some level so the above theory applies to both, with a few trade-offs.

## Polling

__Pros:__

- Easy to implement

- Synchronous with the rest of the program

__Cons:__

- Long input delay

- High CPU overhead


```C
    #define BOUNCE_TIME 50000   // bounce time in usec
```

## Interrupts

__Pros:__

- Short input delay

- Low CPU overhead

__Cons:__

- Requires more complexity

- Harder to implement for real-time applications

__Single Pin:__

Very straight forward implementation that makes almost no sacrifices compared to the theoretical solution.

```C
    #define BOUNCE_TIME 10000   // bounce time in usec

    struct {
        uint8_t a : 1;
        uint8_t reserved : 7;
    } interrupt_pins;

    void on_input_change() {
        if (TIMER_X == BOUNCE_TIME && interrupt_pins.a != raw_pins.a) {
            TIMER_ENABLE = 1;
            interrupt_pins.a = raw_pins.a;
        }
    }

    void on_timeout_X() {
        TIMER_X = BOUNCE_TIME;
        TIMER_ENABLE = 0;
    }
```

This is a very fast, low cpu time input handler. The only significant drawback is that it does not scale well to multiple inputs.

__Multi Pin:__

The main issue with the theoretical solution is scaling to higher numbers of inputs. Timer resources on MCUs are pretty limited and would run out quickly if a new one was used for each input. The common way to address this issue usually seen in keyboards/mice (for slightly different reasons) is to only allow one input change at a time for each port.

The trade off comes when figuring out what to do with changes that occur inside in exclusion window.

```C
    #define BOUNCE_TIME 50000   // bounce time in usec

    struct {
        uint8_t a : 1;
        uint8_t b : 1;
        uint8_t c : 1;
        uint8_t d : 1;
        uint8_t e : 1;
        uint8_t f : 1;
        uint8_t g : 1;
        uint8_t h : 1;
    } interrupt_pins;

    void on_input_change(uint8_t port) {
        static uint8_t old_port;
        uint8_t changed = old_port ^ port;
        if (changed 0x1) {}
        if (changed 0x2) {}
        if (changed 0x3) {}
        if (changed 0x4) {}
        old_port = port;
    }

    void on_timeout_X() {
        TIMER_X = 0;
        TIMER_ENABLE = 0;
    }
```


