package fxrialab.controls.charts
{
	import flash.display.Sprite;
	
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
			//trace('data.value: ', data.value);
			var bar:Sprite = new Sprite();
			bar.graphics.beginFill(data.fill, 1);
			bar.graphics.drawRect(data.marginLeft + data.offSet + data.gapSum + data.barWidthSum, data.height - data.sum - data.marginBottom, data.barWidth, data.value);
			bar.graphics.endFill();
			
			addChild(bar);
			//draw border
			var border:Sprite = new Sprite();
			border.graphics.lineStyle(2, 0xFFFFFF);
			border.graphics.moveTo(data.marginLeft + data.offSet + data.gapSum + data.barWidthSum, data.height - data.marginBottom);
			border.graphics.lineTo(data.marginLeft + data.offSet + data.gapSum + data.barWidthSum, data.height - data.sum - data.marginBottom);
			border.graphics.lineTo(data.marginLeft + data.offSet + data.gapSum + data.barWidthSum + data.barWidth, data.height - data.sum - data.marginBottom);
			border.graphics.lineTo(data.marginLeft + data.offSet + data.gapSum + data.barWidthSum + data.barWidth, data.height - data.marginBottom);
			
			addChild(border);
		}

	}
}