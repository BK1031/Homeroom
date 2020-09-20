![Homeroom](https://github.com/Equinox-Initiative/Homeroom/blob/master/app/images/homeroom-logo.png?raw=true)

As high school students who have to attend school online, we have noticed a larger lack of attention and interaction in online classes than in in-person classes. This is why we created Homeroom, a more fun, interactive meeting software for education that caters to all grade levels. As part of Homeroom, you can move an avatar around a virtual classroom, meeting other students. The audio projected to others scales based on your distance from them in the classroom, allowing you to have better peer-to-peer interactions. Furthermore, you can break out into different table group discussions and ask your teacher for one-on-one help by walking to their desk. You can also get daily assignments by walking to the file cabinet. Homeroom is the perfect solution to create an interactive and focused classroom environment for students to learn in the best way possible.


## How it works

Homeroom is made up of 3 main parts:
- [Frontend](app) (Web Application)
    - Built with Flutter Web, and compiled into native html/js/css
    - Agora frontend page for syncing voice and video
- [Backend](server) (Node.js Server)
    - Monitors Firebase database for new rooms being created
    - Initializes Agora channels for each new room
- [Firebase](https://firebase.com) (Realtime Database & Storage)
    - Stores all users, rooms, classes, etc
    - Stores all user-uploaded content (chat images, profile pictures, teacher assignments) 

Check out Homeroom live [here](https://homeroom.bk1031.dev)!
