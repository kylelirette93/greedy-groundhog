class_name AnimationController extends AnimatedSprite2D

func play_animation(anim: String):
	if (animation != anim):
		play(anim)
