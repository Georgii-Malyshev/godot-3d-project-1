extends Node
#warning-ignore-all:unused_signal


# A global signal bus. Should be added to the project's AutoLoad to be used 
# as a singleton (techically it's won't be a "true" singleton because it can
# still be instanced more than once by the developer; just don't instance 
# it manually and it'll be okay)

# Whenever nodes must be connected via signal(s) in a less than extremely simple & clear manner
# (i.e. anything less obvious than connecting a Timer's parent to that Timer's timeout via GUI),
# don't emit signals from the node directly; use this bus instead. 

# Define any signal that you need here: 
# 	signal ExampleSignal1
# 	signal ExampleSignal2

# In the emitter node use the global signal bus to emit a signal: 
# 	SignalBus.emit_signal("ExampleSignal1", any, number, of, arguments, that, must, be, passed)

# In the node that needs to connect to this signal, again, use the global signal bus like so:
# 	SignalBus.connect("ExampleSignal1", self, "<target_function>" 
# Here, 'SignalBus' is the source node and 'self' is the target node


signal spawn_player(spawn_position)
signal spawn_projectile(original_emitter, projectile_scene, projectile_spawn_spatial)
