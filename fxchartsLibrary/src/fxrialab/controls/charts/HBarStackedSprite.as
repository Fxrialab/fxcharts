package fxrialab.controls.charts
{
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	
	public class HBarStackedSprite extends Sprite
	{
		public function HBarStackedSprite()
		{
			super();
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
		
		public function draw():void 
		{
			//@TODO: still fix gradient for stacked of horizontalBar
			var gradType:String = GradientType.LINEAR;
			var colors:Array = [data.fill, data.fill, data.fill];
			var alphas:Array = [1, 0.6, 0.3];
			var ratios:Array = [0, 30, 255];
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(data.barWidth, data.value*data.heightChart/data.maxValue, 90*(Math.PI/180), data.marginLeft + data.offSet + data.gapSum + data.barWidthSum, data.height - data.sum*data.heightChart/data.maxValue - data.marginBottom);
			
			var bar:Sprite = new Sprite();
			bar.graphics.beginGradientFill(gradType, colors, alphas, ratios, matrix);
			bar.graphics.drawRect(data.marginLeft + data.offSet + data.gapSum + data.barWidthSum, data.height - data.sum*data.heightChart/data.maxValue - data.marginBottom, data.barWidth, data.value*data.heightChart/data.maxValue);
			bar.graphics.endFill();
			
			addChild(bar);
			//draw border
			var border:Sprite = new Sprite();
			border.graphics.lineStyle(2, 0xFFFFFF);
			border.graphics.moveTo(data.marginLeft + data.offSet + data.gapSum + data.barWidthSum, data.height - data.marginBottom);
			border.graphics.lineTo(data.marginLeft + data.offSet + data.gapSum + data.barWidthSum, data.height - data.sum*data.heightChart/data.maxValue - data.marginBottom);
			border.graphics.lineTo(data.marginLeft + data.offSet + data.gapSum + data.barWidthSum + data.barWidth, data.height - data.sum*data.heightChart/data.maxValue - data.marginBottom);
			border.graphics.lineTo(data.marginLeft + data.offSet + data.gapSum + data.barWidthSum + data.barWidth, data.height - data.marginBottom);
			
			addChild(border);
		}

	}
}