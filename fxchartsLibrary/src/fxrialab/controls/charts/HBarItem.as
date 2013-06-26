package fxrialab.controls.charts
{
	import spark.components.supportClasses.SkinnableComponent;
	
	public class HBarItem extends SkinnableComponent
	{
		public function HBarItem()
		{
			super();
		//	this.setStyle("skinClass", HBarItemSkin);
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
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if(data.minValue){
				this.x = data.marginLeft + data.offSet + data.gapSum + data.barWidthSum;
				this.y = data.height - data.value - data.marginBottom - data.minValue;
				this.width = data.barWidth;
				this.height = data.value;
			}else {
				this.x = data.marginLeft + data.offSet + data.gapSum + data.barWidthSum;
				this.y =  data.height - data.value - data.marginBottom;
				this.width = data.barWidth;
				this.height = data.value;
			}
		}
	}
}