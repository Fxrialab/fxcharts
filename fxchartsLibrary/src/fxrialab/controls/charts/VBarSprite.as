package fxrialab.controls.charts 
{
	import flash.display.Sprite;
	import flash.display.GradientType;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class VBarSprite extends Sprite 
	{
		
		public function VBarSprite() 
		{
			super();
			mouseChildren = true;
		}
		
		private var _data:Object;
		
		public function get data():Object
		{
			return _data;
		}

		public function set data(value:Object):void
		{
			if(_data == value) return;
			_data = value;

		}
		
		public function draw():void {
			var gradType:String = GradientType.LINEAR;
			var colors:Array = [data.fill, data.fill, data.fill];
			var alphas:Array = [0.3, 0.6, 1];
			var ratios:Array = [0, 128, 255];
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(data.value, data.barHeight, 0, data.marginLeft, data.height - (data.gapCalc + data.barHeightCalc + data.marginBottom + data.offSet + data.barHeight));
			
			var bar:Sprite = new Sprite();

			bar.graphics.beginGradientFill(gradType, colors, alphas, ratios, matrix);
			if (data.minValue) {
				bar.graphics.drawRect(data.marginLeft + data.minValue, data.height - (data.gapCalc + data.barHeightCalc + data.marginBottom + data.offSet + data.barHeight), data.value, data.barHeight);
			}else {
				bar.graphics.drawRect(data.marginLeft, data.height - (data.gapCalc + data.barHeightCalc + data.marginBottom + data.offSet + data.barHeight), data.value, data.barHeight);
			}
			bar.graphics.endFill();
			
			addChild(bar);
			//draw border
			var border:Sprite = new Sprite();
			border.graphics.lineStyle(2, 0xFFFFFF);
			
			if (data.minValue) {
				border.graphics.moveTo(data.marginLeft + data.minValue, data.height - (data.gapCalc + data.barHeightCalc + data.marginBottom + data.offSet + data.barHeight));
				border.graphics.lineTo(data.marginLeft + data.value + data.minValue, data.height - (data.gapCalc + data.barHeightCalc + data.marginBottom + data.offSet + data.barHeight));
				border.graphics.lineTo(data.marginLeft + data.value + data.minValue, data.height - (data.gapCalc + data.barHeightCalc + data.marginBottom + data.offSet));
				border.graphics.lineTo(data.marginLeft + data.minValue, data.height - (data.gapCalc + data.barHeightCalc + data.marginBottom + data.offSet));
			}else {
				border.graphics.moveTo(data.marginLeft, data.height - (data.gapCalc + data.barHeightCalc + data.marginBottom + data.offSet + data.barHeight));
				border.graphics.lineTo(data.marginLeft + data.value, data.height - (data.gapCalc + data.barHeightCalc + data.marginBottom + data.offSet + data.barHeight));
				border.graphics.lineTo(data.marginLeft + data.value, data.height - (data.gapCalc + data.barHeightCalc + data.marginBottom + data.offSet));
				border.graphics.lineTo(data.marginLeft, data.height - (data.gapCalc + data.barHeightCalc + data.marginBottom + data.offSet));
			}
			
			addChild(border);		
			//text format for label field and value field
			var labelFieldFormat:TextFormat = new TextFormat();
			labelFieldFormat.size = 7;
			labelFieldFormat.font = 'Arial';
			labelFieldFormat.align = 'left';
			labelFieldFormat.color = data.fill;
			
			var valueFieldFormat:TextFormat = new TextFormat();
			valueFieldFormat.size = 7;
			valueFieldFormat.font = 'Verdana';
			valueFieldFormat.align = 'left';
			valueFieldFormat.color = 0x000000;

			//draw label field
			var labelField:TextField = new TextField();
			labelField.text = data.label;
			if(data.minValue) {
				labelField.x = data.marginLeft + data.value + data.minValue + 7;
			}else {
				labelField.x = data.marginLeft + data.value + 7;
			}
			labelField.y = data.height - (data.gapCalc + data.barHeightCalc + data.marginBottom + data.offSet + data.barHeight/ 2);
			labelField.setTextFormat(labelFieldFormat);
			addChild(labelField);
			//draw value field
			var valueField:TextField = new TextField();
			valueField.text = data.value;
			if(data.minValue) {
				valueField.x = data.marginLeft + data.value + data.minValue + 7;
			}else {
				valueField.x = data.marginLeft + data.value + 7;
			}
			valueField.y = data.height - (data.gapCalc + data.barHeightCalc + data.marginBottom + data.offSet + data.barHeight - 3);
			valueField.setTextFormat(valueFieldFormat);
			addChild(valueField);

		}
	}

}