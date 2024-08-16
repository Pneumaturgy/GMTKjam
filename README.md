This is the documentation for the Pneumaturgy Godot Ui Mobile Template. It is used for quickly setting up projects for these purposes, and here I will explain what this project holds and what you can expect.

## New Machine?

<aside>
:bulb: If you’re setting this up on a new machine, make sure you install the necessary build materials:

[Export to Android](https://www.youtube.com/watch?v=dCLYMF32ZBE&t=1s).

1. **Set Up Android Studio**
    - Download and install from [Android Studio](https://developer.android.com/studio).
    - Download JDK from [Oracle](https://www.oracle.com/java/technologies/downloads).
2. **Manage Export Templates**
    - `Editor / Manage Export Templates`
    - Download from the official GitHub releases mirror and install.
3. **Configure Editor Settings for Android Export**
    - `Editor / Editor Settings / Export Android`
    - Navigate to **`%AppData%\Local\Android\Sdk`** and copy the path, Set the Android SDK path in editor settings.
    - Find the Java JDK in Program Files and paste as Java SDJ Path
    
    
4. **Generate Debug Keystore**
    - Navigate to `C:\Program Files\Java\jdk-22\bin` copy address
    - Open CMD as admin
    - cd to above address
    - and run:
        
        ```bash
        keytool -genkey -v -keystore debug.keystore -storepass android -alias androiddebugkey -keypass android -keyalg RSA -keysize 2048 -validity 10000 -dname "C=US, O=Android, CN=Android Debug"
        ```
        
    - Configure editor settings to use the debug keystore. navigate to path, jdk, bin, find keystore
    - Use `androiddebugkey` for the user and `android` for the password.
5. **Final Export Settings**
    - Enable import for ETC2 and ASTC textures in project settings and restart.
    - Add Android export template and set package name according to Android conventions.
    - Export the project, enable "debug" mode, and upload the APK to your device.
</aside>

## Change Icon

1. Navigate to `Project / Project Settings / General / Application / Config / Icon`
2. Select a new image 

## Folder Structure

> *The first thing you will notice as you open the example project is the folder structure. This is purely best practices because accessing files from the filepath can be a delicate process. Make sure you try to stick to the folder structure as much as possible*
> 

### Assets:

1. 2D
    1. 2D Particles
    2. Sprites
    3. Textures
2. 3D
    1. 3D Particles
    2. Materials
    3. Meshes
    4. Prefabs
3. Fonts
4. Shaders
5. Skyboxes
6. Sound
    1. Music
    2. SFX

### Scenes

1. Main.tscn

> *This main scene serves to demostrate the default viewport settings in the UI for a mobile scene. Notice the vertical dimensions, and a control notes that is anchored to full rect. See below: “[Viewport Set Up](https://www.notion.so/Godot-Mobile-UI-Template-e9b1ad282d564168913c87a941cd32bd?pvs=21)”*
> 

### Scripts

1. Global
> *This Global script is set up in the autoload settings. See below - “[Autoload Set UP](https://www.notion.so/Godot-Mobile-UI-Template-e9b1ad282d564168913c87a941cd32bd?pvs=21)”*
> 
### Tests

1. Unit



## Viewport Set Up

`Project / Project Settings / Display / Window`


1. Viewport Width: `1080`, Viewport Height: `1920`
2. Stretch mode: `canvas_items` 
3. Handheld Orientation: `portrait`
    1. Optional: Window Width Override: `1080 / 1.5` , Window Height Override: `1920 / 1.5`
    2. Alternatively halve them again to get the desired size
    

## Autoload Set Up

1. Create a new script in the scripts folder
2. call it `Global`
3. Navigate to `Project / Project Settings / Autoload`
4. click `Path`, navigate to Globals script. It will populate on the left side of the screen
5. Click `Add`


<aside>
🚨 Please note that the autoload contains example save / load functionality, as well as a “quit game” function that can be called from any script.

</aside>

## [GUT - Godot Unit Tests](https://gut.readthedocs.io/en/latest/)

1. Navigate to `AssetLib` search for `GUT`, Click Download on `GUT - Godot Unit Testing`
2. Navigate to `Project / Project Settings / Plugins`
    1. Select `enable`

For purposes of this Quick Start guide, create a script file `res://test/unit/test_example.gd` with the following content:

```jsx
extends GutTest

func test_passes():
	# this test will pass because 1 does equal 1
	assert_eq(1, 1)
	
func test_fails():
	# this test will fail because those strings are not equal
	assert_eq('hello', 'goodbye')
```

# **Run Tests[](https://gut.readthedocs.io/en/latest/Quick-Start.html#run-tests)**

<aside>
🚨 You may have to restart the engine to see all the settings.

</aside>

- Open the GUT panel

!https://gut.readthedocs.io/en/latest/_images/gut_panel_where.png

- Configure the directories where your tests are in the GUT Panel settings (you may need to scroll down to see this section). If you created the example test above, this would be in `res://test/unit`. A good strategy with GUT is to separate unit and integration tests into separate directory structures (such as `res://test/unit` and `res://test/integration`). Once you get a lot of tests, this will make it easier to run the fast unit tests frequently, and the slower integration tests only as often as is useful.

!https://gut.readthedocs.io/en/latest/_images/gut_panel_test_directories.png

- Click “Run All” to run all your tests.
- Open a test script and click the button with your test script’s name (`test_test.gd` in image below) to run only that test script.
- Open a test script, put the cursor inside a test function, click the button with your test function’s name (`test_fails_when_number_not_equal` in the image below) to run just that one test.

!https://gut.readthedocs.io/en/latest/_images/gut_panel.png

Mouse-over labels and buttons in the GUT panel for more information. You can even set keyboard shortcuts for all of the GUT panel actions.

## Conclusion - Export

1. Navigate to `Project / Export`
2. Add… `Android`
3. Navigate to `Package Name`
    1. Change Unique Name by removing everything including and after the $, and replacing with your game name
    2. Change Game Name

This project is now ready to be used. I recommend importing your initial assets and trying to export. If you are not able to find the export window, you may need to download export templates; [see above](https://www.notion.so/Godot-Mobile-UI-Template-e9b1ad282d564168913c87a941cd32bd?pvs=21)

## CI / CD

The `.github\workflows\ci.yaml` file is included to allow for CI/CD.

1. This is the GitHub Action that runs CI
2. on every `git push` event (any branch, including merges to `main`), this runs our GUT tests

Read more:
https://aws.amazon.com/devops/continuous-integration/

https://github.com/features/actions
