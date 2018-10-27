import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/resizable.dart';
import 'package:flame/sprite.dart';
import 'package:trex/game/custom/composed_component.dart';
import 'package:trex/game/custom/util.dart';
import 'package:trex/game/horizon/config.dart';


class CloudManager extends PositionComponent with ComposedComponent{
  Image spriteImage;
  CloudManager(this.spriteImage) : super();

  @override
  void updateWithSpeed(t, double speed) {
    final double cloudSpeed = HorizonConfig.bgCloudSpeed / 1000 * t * speed;
    final int numClouds = this.components.length;

    print(components.length > 0 ? (components.elementAt(0) as Cloud).y : "none");

    if(numClouds > 0) {
      this.updateComponents((c) {
        Cloud cloud = c as Cloud;
        cloud.updateWithSpeed(cloudSpeed);
      });
      Cloud lastCloud = components.last;
      if(numClouds < HorizonConfig.maxClouds &&
          (HorizonDimensions.width - lastCloud.x) > lastCloud.cloudGap &&
          HorizonConfig.cloudFrequency > rnd.nextDouble()
      ) {
        addCloud();
      }
    } else {
      addCloud();
    }

  }

  addCloud(){
    Cloud cloud = Cloud(spriteImage);
    cloud.x = HorizonDimensions.width;
    cloud.y = (y/2 - (CloudConfig.maxSkyLevel - CloudConfig.minSkyLevel)) + getRandomNum(CloudConfig.minSkyLevel, CloudConfig.maxSkyLevel);
    components.add(cloud);
  }
}


class Cloud extends SpriteComponent with Resizable {
  final double cloudGap;
  bool toRemove = false;


  Cloud(Image spriteImage) :
        cloudGap = getRandomNum(CloudConfig.minCloudGap, CloudConfig.maxCloudGap),
        super.fromSprite(
          CloudConfig.width,
          CloudConfig.height,
          Sprite.fromImage(spriteImage,
            width: CloudConfig.width,
            height: CloudConfig.height,
            y: 2.0,
            x: 166.0,
          )
        );

  void update(double t){

  }

  void updateWithSpeed(double speed) {
    if(toRemove) return;
    x -= speed.ceil();

    if(!isVisible){
      this.toRemove = true;
    }

  }

  bool destroy() {
    return toRemove;
  }



  bool get isVisible {
    return x + CloudConfig.width > 0;
  }
}