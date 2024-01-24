import QtQuick 2.0
import QtGraphicalEffects 1.0

Rectangle {
    width: 320
    height: 480


    Rectangle{
        id: dialcontener
        anchors.centerIn: parent
        width: 200
        height: 200
        radius: 100
        color: "black"
        Repeater
        {
            id: dial

            model:12
            delegate: Item {
                width: 30
                height: 30
                property int nr: index

                x: (Math.cos( index*Math.PI/6 )+1)/2 * (parent.width - width )
                y: (Math.sin( index*Math.PI/6 )+1)/2 * (parent.height - height )

                //onActiveChanged: { dot.opacity= active?1.0:0.0; }

                states: [ State {
                        name: "active"
                        PropertyChanges {
                            target: dot
                            color: "white"
                        }
                    },
                    State {
                        name: "current"
                        PropertyChanges {
                            target: dot
                            color: "blue"
                        }
                    }
                ]

                transitions: [
                    Transition
                    {
                        ColorAnimation {
                            properties: "color"
                            easing.type: Easing.InQuad
                            duration: 300
                        }

                    }
                ]

                Rectangle {
                    id:dot
                    x:5
                    y:5
                    width: 20
                    height: 20
                    radius: 10
                    color: "black"
               }

                Rectangle {
                    id:circle
                    x:5
                    y:5
                    width: 20
                    height: 20
                    radius: 10
                    border.color: "white"
                    border.width: 1
                    color: "transparent"
               }

                Text {
                    id: t1
                    anchors.centerIn: parent
                    text: index+""
                    color: "white"
                }
            }
        }
        Text {
            id: valt1
            anchors.centerIn: parent
            text: qsTr("Unlock")
            color: "white"
        }
    }


    Text {
        id: pass1
        anchors.top: dialcontener.bottom
        anchors.left: dialcontener.left
        text: 'Password: '
    }

    MouseArea {
        anchors.fill: parent


        function getIndex(x,y)
        {
            return Math.round( (Math.atan2( height/2 - y, width/2 - x )/Math.PI + 1) * dial.count/2 ) % dial.count;
        }

        function valToChar(v){
            if(v<10) return v+"";
            return String.fromCharCode(v-10+"A".charCodeAt(0));
        }

        property int start: 0
        property int curent: 0
        property int direction: 0
        property int value

        onPressed: {
            dial.itemAt(start= curent= getIndex(mouse.x,mouse.y)).state="current";
            value=0;
            pass1.text= 'Password: ';
        }
        onPositionChanged: {
            var newCurent=getIndex(mouse.x,mouse.y);
            var newDirection= newCurent - curent;
            if(newDirection>6) newDirection=-1; else
            if(newDirection<-6) newDirection=1; else
            if(newDirection<0) newDirection=-1; else
            if(newDirection>0) newDirection=1;

            if( newDirection!=0 && direction != newDirection)
            {
                for( var i=0; i<dial.count; ++i )
                    dial.itemAt(i).state="";
                if(value>0)
                {
                    pass1.text= pass1.text + valToChar(value);
                }

                value=0;
                direction= newDirection;
            }

            for( var i=curent; i != newCurent; i=(newDirection+i+dial.count)%dial.count )
            {
                value++;
                valt1.text=valToChar(value);
                console.debug("[D] d[",i,"]");
                dial.itemAt(i).state="active";
            }
            dial.itemAt(newCurent).state="current";
            curent=newCurent;

        }
        onReleased: {
            for( var i=0; i<dial.count; ++i )
                dial.itemAt(i).state="";
            pass1.text= pass1.text + valToChar(value);
        }

    }
}
