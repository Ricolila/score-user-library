import Score
import QtQuick

ScriptUI {
  id: root
  anchors.fill: parent

  property var modelState
  property var executionState
  property var slider: root.inlet("Control")
  Component.onCompleted: console.log("Slider: ", slider);

  executionEvent: function(message) {
    console.log("(ui): exec -> ui", message);
    executionState = message;
  }

  loadState: function(state) {
    modelState = state;
    console.log("ui: loadState", JSON.stringify(modelState));
  }

  stateUpdated: function(k, v) {
    console.log("(ui): onStateElementChanged", k, JSON.stringify(v));
  }

  Column {
    anchors.fill: parent
    Text {
      text: executionState !== undefined ? executionState.foo : 0;
    }
    Text {
      text: slider.value
    }
  }
  MouseArea {
    anchors.fill: root
    onClicked: {
      console.log("(ui): ui -> exec", {x: mouseX, y: mouseY});
      root.executionSend({x: mouseX, y: mouseY});
      slider.value = Math.random() * 100;
    }

    onPressed: { root.beginUpdateState("Edit");  }
    onPositionChanged: { root.updateState("Mouse", {x: mouse.x, y: mouse.y}); }
    onReleased: { root.endUpdateState();  }
  }
}
