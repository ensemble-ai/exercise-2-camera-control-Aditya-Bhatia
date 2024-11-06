# Peer-Review for Programming Exercise 2 #

## Description ##

For this assignment, you will be giving feedback on the completeness of assignment two: Obscura. To do so, we will give you a rubric to provide feedback. Please give positive criticism and suggestions on how to fix segments of code.

You only need to review code modified or created by the student you are reviewing. You do not have to check the code and project files that the instructor gave out.

Abusive or hateful language or comments will not be tolerated and will result in a grade penalty or be considered a breach of the UC Davis Code of Academic Conduct.

If there are any questions at any point, please email the TA.   

## Due Date and Submission Information
See the official course schedule for due date.

A successful submission should consist of a copy of this markdown document template that is modified with your peer review. This review document should be placed into the base folder of the repo you are reviewing in the master branch. The file name should be the same as in the template: `CodeReview-Exercise2.md`. You must also include your name and email address in the `Peer-reviewer Information` section below.

If you are in a rare situation where two peer-reviewers are on a single repository, append your UC Davis user name before the extension of your review file. An example: `CodeReview-Exercise2-username.md`. Both reviewers should submit their reviews in the master branch.  

# Solution Assessment #

## Peer-reviewer Information

* *name:* [Jhaydine Bandola] 
* *email:* [jybandola@ucdavis.edu]

### Description ###

For assessing the solution, you will be choosing ONE choice from: unsatisfactory, satisfactory, good, great, or perfect.

The break down of each of these labels for the solution assessment.

#### Perfect #### 
    Can't find any flaws with the prompt. Perfectly satisfied all stage objectives.

#### Great ####
    Minor flaws in one or two objectives. 

#### Good #####
    Major flaw and some minor flaws.

#### Satisfactory ####
    Couple of major flaws. Heading towards solution, however did not fully realize solution.

#### Unsatisfactory ####
    Partial work, not converging to a solution. Pervasive Major flaws. Objective largely unmet.


___

## Solution Assessment ##

### Stage 1 ###

- [ ] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [x] Unsatisfactory

___
#### Justification ##### 
The camera does not function as a target lock on the vessel, instead it works exactly as the PushBoxCamera.

___
### Stage 2 ###

- [ ] Perfect
- [ ] Great
- [ ] Good
- [x] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
The camera auto scrolls at a constant speed, but does not take into account the vessels movement. This means that this not fufills the stages
requirement of pushing th vessel when it reaches the left side of the box.

___
### Stage 3 ###

- [x] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
The camera correctly does not immediately center on the player as the player moves, it approaches the player's position. The camera correctly follows the player at  slower speed than the player speed. It also catches up to the player when the player halts.

___
### Stage 4 ###

- [ ] Perfect
- [x] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
The camera correctly leads the player in the direction of the player's input. The position of the camera approaches to the player's position when the player stops moving and settles on the target when it has not moved. However, the one flaw I notice is that when it reaches the maximum leash, the vessel begins to stuttter.

___
### Stage 5 ###

- [ ] Perfect
- [x] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
The camera seems to work great in the sense that the camera doesn't move when it is in the speedzone. When the camera is in the pushzone, it moves the camera at the necessary spped. One flaw that I can point out is that when the vessel is moving around int he speed zone, it seems way faster than when it is outside of the speedzone.
___
# Code Style #


### Description ###
Check the scripts to see if the student code adheres to the GDScript style guide.

If sections do not adhere to the style guide, please peramlink the line of code from Github and justify why the line of code has not followed the style guide.

It should look something like this:

* [description of infraction](https://github.com/dr-jam/ECS189L) - this is the justification.

Please refer to the first code review template on how to do a permalink.


#### Style Guide Infractions ####

#### Style Guide Exemplars ####
* [Many of the files adhere to one style per line](https://github.com/ensemble-ai/exercise-2-camera-control-Aditya-Bhatia/blob/6467e7c75de88b00f44649b5bfd9a3645d727921/Obscura/scripts/camera_controllers/position_lock_lerp.gd#L27)

* [Comments are properly spaced out](https://github.com/ensemble-ai/exercise-2-camera-control-Aditya-Bhatia/blob/6467e7c75de88b00f44649b5bfd9a3645d727921/Obscura/scripts/camera_controllers/lerp_target_focus.gd#L45)

* [There is appropiate white sapce within code for each files](https://github.com/ensemble-ai/exercise-2-camera-control-Aditya-Bhatia/blob/6467e7c75de88b00f44649b5bfd9a3645d727921/Obscura/scripts/camera_controllers/lerp_target_focus.gd#L40 )

* [Code order](https://github.com/ensemble-ai/exercise-2-camera-control-Aditya-Bhatia/blob/6467e7c75de88b00f44649b5bfd9a3645d727921/Obscura/scripts/camera_controllers/speedup_push_zone.gd#L4) for files are consistent and follow good styel guides.
___
#### Put style guide infractures ####

* [There has been inconcsitent declarations of variables of type float](https://github.com/ensemble-ai/exercise-2-camera-control-Aditya-Bhatia/blob/6467e7c75de88b00f44649b5bfd9a3645d727921/Obscura/scripts/camera_controllers/position_lock_lerp.gd#L7), some variables have their trailing 0s omiited. 
___

# Best Practices #

### Description ###

If the student has followed best practices then feel free to point at these code segments as examplars. 

If the student has breached the best practices and has done something that should be noted, please add the infraction.


This should be similar to the Code Style justification.

#### Best Practices Infractions ####

* There are a total of 4 commits, but a best practice is to make small and frequent commits. 

#### Best Practices Exemplars ####
* [There are comments that explain code associated with concepts that may not be as intutiive as other stages' codes](https://github.com/ensemble-ai/exercise-2-camera-control-Aditya-Bhatia/blob/6467e7c75de88b00f44649b5bfd9a3645d727921/Obscura/scripts/camera_controllers/lerp_target_focus.gd#L45)

* [Naming conventions of the variables are descriptive](https://github.com/ensemble-ai/exercise-2-camera-control-Aditya-Bhatia/blob/6467e7c75de88b00f44649b5bfd9a3645d727921/Obscura/scripts/camera_controllers/speedup_push_zone.gd#L40) they make sense and are benefical to reader.
