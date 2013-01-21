package fxrialab.controls.charts
{
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class HBarSprite extends Sprite
	{
		public function HBarSprite()
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
			var alphas:Array = [1, 0.6, 0.3];
			var ratios:Array = [0, 30, 255];
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(data.barWidth, data.value, 90*(Math.PI/180), data.marginLeft + data.offSet + data.gapSum + data.barWidthSum, data.height - data.value - data.marginBottom);
			
			var bar:Sprite = new Sprite();
			
			bar.graphics.beginGradientFill(gradType, colors, alphas, ratios, matrix);
			if(data.minValue){
				bar.graphics.drawRect(data.marginLeft + data.offSet + data.gapSum + data.barWidthSum, data.height - data.value - data.marginBottom + data.minValue, data.barWidth, data.value);
			}else {
				bar.graphics.drawRect(data.marginLeft + data.offSet + data.gapSum + data.barWidthSum, data.height - data.value - data.marginBottom, data.barWidth, data.value);
			}
			bar.graphics.endFill();
			
			addChild(bar);
			//draw border
			var border:Sprite = new Sprite();

			border.graphics.lineStyle(2, 0xFFFFFF);
			if(data.minValue) {
				border.graphics.moveTo(data.marginLeft + data.offSet + data.gapSum + data.barWidthSum, data.height - data.marginBottom + data.minValue);
				border.graphics.lineTo(data.marginLeft + data.offSet + data.gapSum + data.barWidthSum, data.height - data.value - data.marginBottom + data.minValue);
				border.graphics.lineTo(data.marginLeft + data.offSet + data.gapSum + data.barWidthSum + data.barWidth, data.height - data.value - data.marginBottom + data.minValue);
				border.graphics.lineTo(data.marginLeft + data.offSet + data.gapSum + data.barWidthSum + data.barWidth, data.height - data.marginBottom + data.minValue);
			}else {
				border.graphics.moveTo(data.marginLeft + data.offSet + data.gapSum + data.barWidthSum, data.height - data.marginBottom);
				border.graphics.lineTo(data.marginLeft + data.offSet + data.gapSum + data.barWidthSum, data.height - data.value - data.marginBottom);
				border.graphics.lineTo(data.marginLeft + data.offSet + data.gapSum + data.barWidthSum + data.barWidth, data.height - data.value - data.marginBottom);
				border.graphics.lineTo(data.marginLeft + data.offSet + data.gapSum + data.barWidthSum + data.barWidth, data.height - data.marginBottom);
			}

			addChild(border);
			
			//text format for label field and value field				
			var labelFieldFormat:TextFormat = new TextFormat();
			labelFieldFormat.size = 7;
			labelFieldFormat.font = 'Arial';
			labelFieldFormat.align = 'center';
			labelFieldFormat.color = data.fill;
			
			var valueFieldFormat:TextFormat = new TextFormat();
			valueFieldFormat.size = 7;
			valueFieldFormat.font = 'Arial';
			valueFieldFormat.align = 'center';
			valueFieldFormat.color = 0x000000;

			//draw label field
			var labelField:TextField = new TextField();
			labelField.text = data.label;
			labelField.x = data.marginLeft + data.offSet + data.gapSum + data.barWidthSum;
			if(data.minValue) {
				labelField.y = data.height - data.marginBottom - (data.value + 12) + data.minValue;
			}else {
				labelField.y = data.height - data.marginBottom - (data.value + 12);
			}
			labelField.width = data.barWidth;
			labelField.setTextFormat(labelFieldFormat);
			addChild(labelField);
			
			//draw value field
			var valueField:TextField = new TextField();
			valueField.text = data.value;
			valueField.x = data.marginLeft + data.offSet + data.gapSum + data.barWidthSum;
			if(data.minValue) {
				valueField.y = data.height - data.marginBottom - (data.value + 22) + data.minValue;
			}else {
				valueField.y = data.height - data.marginBottom - (data.value + 22);
			}
			valueField.width = data.barWidth;
			valueField.setTextFormat(valueFieldFormat);
			addChild(valueField);

		}

	}
}