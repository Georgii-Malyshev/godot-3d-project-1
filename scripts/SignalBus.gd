extends Node
#warning-ignore-all:unused_signal


# A global signal bus. Should be added to the project's AutoLoad to be used 
# as a singleton (techically it's won't be a "true" singleton because it can
# still be instanced more than once by the developer; just don't instance 
# it manually and it'll be okay)


# Define any signal that you need here: 
# signal ExampleSignal1
# signal ExampleSignal2


# Whenever a signal must be emitted, don't emit it from the node directly; 
# use this bus instead. 

# In the emitter node use the global signal bus to emit a signal: 

# SignalBus.emit_signal("ExampleSignal1", self.whatever_you_need_to_pass_from_emitter)

# In the node that needs to connect to this signal, again, use the global signal bus:

# SignalBus.connect("ExampleSignal1", self, "<target_function>" 
# Here, 'SignalBus' is the source node and 'self' is the target node


signal shootProjectile(projectile, spawnPoint)