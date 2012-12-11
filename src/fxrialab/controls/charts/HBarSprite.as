package fxrialab.controls.charts
{
	import flash.display.GradientType;
	import flash.display.Sprite;
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
			var colors:Array = [];
			var alphas:Array = [1, 1];
			var ratios:Array = [0, 255];
			var bar:Sprite = new Sprite();
			
			bar.graphics.clear();
			if (data.fill.search(',') == -1) {
				bar.graphics.beginFill(data.fill, 1);
			}else {
				var getGradientColor:String = data.fill;
				var getFirstColor:uint = uint(getGradientColor.substring(0, getGradientColor.indexOf(',')));
				var getSecondColor:uint = uint(getGradientColor.substring(getGradientColor.indexOf(',')+1, getGradientColor.length));
				colors.push(getFirstColor, getSecondColor);

				bar.graphics.beginGradientFill(gradType, colors, alphas, ratios);
			}
			bar.graphics.drawRect(data.marginLeft + data.offSet + data.gapSum + data.barWidthSum, data.height - data.value - data.marginBottom, data.barWidth, data.value);
			bar.graphics.endFill();
			
			addChild(bar);
			//draw border
			var border:Sprite = new Sprite();

			border.graphics.lineStyle(2, 0xFFFFFF);
			border.graphics.moveTo(data.marginLeft + data.offSet + data.gapSum + data.barWidthSum, data.height - data.marginBottom);
			border.graphics.lineTo(data.marginLeft + data.offSet + data.gapSum + data.barWidthSum, data.height - data.value - data.marginBottom);
			border.graphics.lineTo(data.marginLeft + data.offSet + data.gapSum + data.barWidthSum + data.barWidth, data.height - data.value - data.marginBottom);
			border.graphics.lineTo(data.marginLeft + data.offSet + data.gapSum + data.barWidthSum + data.barWidth, data.height - data.marginBottom);

			addChild(border);
			
			//text format for label field and value field				
			var labelFieldFormat:TextFormat = new TextFormat();
			labelFieldFormat.size = 7;
			labelFieldFormat.font = 'Arial';
			labelFieldFormat.align = 'center';
			var getTxtColor:uint = (colors.length > 0) ? colors[0] : data.fill;
			labelFieldFormat.color = getTxtColor;
			
			var valueFieldFormat:TextFormat = new TextFormat();
			valueFieldFormat.size = 7;
			valueFieldFormat.font = 'Arial';
			valueFieldFormat.align = 'center';
			valueFieldFormat.color = 0x000000;

			//draw label field
			var labelField:TextField = new TextField();
			labelField.text = data.label;
			labelField.x = data.marginLeft + data.offSet + data.gapSum + data.barWidthSum;
			labelField.y = data.height - data.marginBottom - (data.value + 12);
			labelField.width = data.barWidth;
			labelField.setTextFormat(labelFieldFormat);
			addChild(labelField);
			
			//draw value field
			var valueField:TextField = new TextField();
			valueField.text = data.value;
			valueField.x = data.marginLeft + data.offSet + data.gapSum + data.barWidthSum;
			valueField.y = data.height - data.marginBottom - (data.value + 22);
			valueField.width = data.barWidth;
			valueField.setTextFormat(valueFieldFormat);
			addChild(valueField);

		}

	}
}