extends Node
class_name Splat

# Assign properties from the dictionary into the target object
static func into( target :Object, props :Dictionary ) -> Object:
	assert( target != null, "Cannot splat into a null object" )
	if OS.is_debug_build():
		if props == null or props.empty():
			push_warning("Splatted null or empty dictionary into object")
			return target

	for prop in props:
		if prop in target:
			target.set(prop, props[prop])
		elif Engine.editor_hint or OS.is_debug_build():
			push_warning("Cannot splat. Object doesn't have property '%s'" % prop)
	return target
