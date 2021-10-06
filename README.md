# AimExp

AimExp is an open-source software for experiment on aiming in first-person shooter games.

# Introduction

This project was created using the Godot Engine[1] following the Godot FPS tutorial[2]. Below are two motivating examples that explain the goal of AimExp.

# Spatial visualization and tracking

Tracking a moving target using crosshair is one of the most common scenarios in FPS games. An interesting observation is that theoretically the better you track a target, the harder you perceive the movement of the target (since it should stays stable at the center of your screen).

There is a saying in the aiming community that we sometimes aim with our spatial visualization. It is reasonable to conjecture that we utilize the change of the background to infer the actual 3D movement of the target. It is possible that we reconstruct the virtual 3D space in our brain and visualize the 3D movement of the target to adjust our view on it. 

A simple method to figure out how much we rely on our spatial visualization and the background information in tracking is to remove the background and compare our performance to the normal situation. We provide an implementation of this experiment in AimExp so that users can try it themselves and obtain their results. The users can simply toggle off the Show walls option in the option of aiming task to remove the background.

# Submovement and rotation speed

There is an opinion that our cursor movement process using computer mouse is an intermittent control process, which means that the moving process consist of several submovements and the visual feedback control only happen intermittently at the beginning of each submovement. Readers can refer to [3, 4] for further explaination. A study of professional CS:GO players [5] found that they use less submovements than amateurs in aiming. Further more, [5] points out that althought professional players use lower edpi and move mouse faster, their rotation speed (edpi * mouse speed) is similar to amateurs'. It is thus an interesting topic to study the relation among the aiming performance, the submovement numbers and the rotation speed. AimExp provides the function to plot the speed chart of the rotation so that we can recognize the submovement in our aiming and read out the rotation speed by screen recording. From that, users can obtain further understanding of their aiming.

# License

This project uses the MIT license and further development are welcome to discover more interesting aspects of FPS aiming. If you need some support, send an email to benkyoujouzu@gmail.com.

# Reference

[1] Godot Engine. https://godotengine.org/
[2] Godot FPS Tutorial. https://docs.godotengine.org/en/stable/tutorials/3d/fps_tutorial/index.html
[3] Park, E., & Lee, B. (2020, April). An Intermittent Click Planning Model. In Proceedings of the 2020 CHI Conference on Human Factors in Computing Systems (pp. 1-13).
[4] Martín, J. A. Á., Gollee, H., Müller, J., & Murray-Smith, R. (2021). Intermittent control as a model of mouse movements. ACM Transactions on Computer-Human Interaction (TOCHI), 28(5), 1-46.
[5] Park, E., Lee, S., Ham, A., Choi, M., Kim, S., & Lee, B. (2021, May). Secrets of Gosu: Understanding Physical Combat Skills of Professional Players in First-Person Shooters. In Proceedings of the 2021 CHI Conference on Human Factors in Computing Systems (pp. 1-14).