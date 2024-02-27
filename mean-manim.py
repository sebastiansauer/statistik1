from manim import *

class ArithmeticMeanScene(Scene):
    def construct(self):
        # Create rectangles to represent the bars
        rect1 = Rectangle(height=1, width=0.2).set_fill(BLUE, opacity=0.5)
        rect2 = Rectangle(height=2, width=0.2).set_fill(BLUE, opacity=0.5).next_to(rect1, RIGHT, buff=0.1)
        rect3 = Rectangle(height=3, width=0.2).set_fill(BLUE, opacity=0.5).next_to(rect2, RIGHT, buff=0.1)

        group = VGroup(rect1, rect2, rect3)
        # Position group in the center
        group.move_to(ORIGIN)

        # Create target rectangles
        target_rects = VGroup(
            Rectangle(height=2, width=0.2).set_fill(RED, opacity=0.5),
            Rectangle(height=2, width=0.2).set_fill(RED, opacity=0.5),
            Rectangle(height=2, width=0.2).set_fill(RED, opacity=0.5)
        )

        # Position target rectangles in the same location as original rectangles
        for target, original in zip(target_rects, group):
            target.move_to(original.get_center())

        # Create the equation
        equation = Tex("1 + 2 + 3 = 3 \\cdot 2").to_edge(UP)

        # Add rectangles and equation to the scene
        self.add(group, equation)

        # Morph the original rectangles into the target rectangles
        self.play(
            Transform(rect1, target_rects[0]),
            Transform(rect2, target_rects[1]),
            Transform(rect3, target_rects[2]),
            run_time=2
        )

        # Keep the final image for a while before exiting
        self.wait(2)

