import QtQuick 2.15
import Bobink
import "../.."
StatusIndicator {
    id: statusIndicator
    width: parent.width * 0.2
    height: width
    required property string nodeIdRed
    required property string nodeIdYellow
    required property string nodeIdGreen


    OpcUaMonitoredNode {
        monitored: statusIndicator.visible
        id: statusIndicatorButtonCantreNodeIdRed
        nodeId: nodeIdRed
        onValueChanged:{
                if(value === 1){
                    parent.color =  "red"
                    parent.enable = value
                }
                else{
                    parent.enable = value
                }
            }

    }
    OpcUaMonitoredNode {
        monitored: statusIndicator.visible
        id: statusIndicatorButtonCantreNodeIdYellow
        nodeId: nodeIdYellow
        onValueChanged:{
                if(value === 1){
                    parent.color =  "yellow"
                    parent.value = value
                }
                else{
                    parent.value = value
                }
            }
    }
    OpcUaMonitoredNode {
        monitored: statusIndicator.visible
        id: statusIndicatorButtonCantreNodeIdGreen
        nodeId: nodeIdGreen
        onValueChanged:{
                if(value === 1){
                    parent.color =  "green"
                    parent.value = value
                }
                else{
                    parent.value = value
                }
            }
    }

}
