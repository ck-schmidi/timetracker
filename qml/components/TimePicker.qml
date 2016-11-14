import VPlay 2.0
import QtQuick 2.7
import QtQuick.Controls 2.0

Item{
    height: dp(100)
    width: row.width

    property int visibleItems: 3
    property alias currentHours: hourTumbler.currentIndex
    property alias currentMinutes: minutesTumbler.currentIndex

    signal anyValueChanged

    onCurrentHoursChanged: anyValueChanged()
    onCurrentMinutesChanged: anyValueChanged()

    Component{
        id: tumblerDelegate
        Text{
            text: {
                if(modelData < 10)
                    return "0" + modelData
                return modelData
            }
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: dp(20)
            opacity: 1.0 - Math.abs(Tumbler.displacement) / (visibleItems / 2)
        }
    }

    Row{
        id: row
        Tumbler {
            id: hourTumbler
            width: dp(50)
            model: 24
            delegate: tumblerDelegate
        }
        Tumbler {
            id: minutesTumbler
            width: dp(50)
            model: 60
            delegate: tumblerDelegate
        }
    }
}

