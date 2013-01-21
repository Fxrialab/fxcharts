package fxrialab.controls.charts
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import mx.collections.IList;
	import mx.core.UIComponent;
	
	import spark.components.supportClasses.SkinnableComponent;
	
	public class DoughnutCharts extends SkinnableComponent
	{
		private var _dataProvider:IList;
		private var redrawSkin:Boolean = false;
		
		private var _labelField:String = "label";
		private var _valueField:String = "value";
		private var _fillField:String = "fill";
		private var _data:Object;
		
		private var _marginTop:Number;
		private var _marginRight:Number;
		private var _marginBottom:Number;
		private var _marginLeft:Number;
		
		public var doughnuts:Array = [];
		public var explodeDistance:int = 10;
		
		[SkinPart]
		public var doughnutHolder:UIComponent;
		
		public function DoughnutCharts()
		{
			super();
			mouseChildren = true;						
			this.setStyle('skinClass', DoughnutChartSkin);
		}
		
		public function get dataProvider():IList
		{
			return _dataProvider;
		}
		
		private var sumValue:int = 0;
		private var arrays:Array = [];

		public function set dataProvider(value:IList):void
		{
			if (value == _dataProvider) return;
			
			_dataProvider = value;
			redrawSkin = true;
			invalidateProperties();
			
			for (var i:int = 0; i < dataProvider.length; i++) {
				data = dataProvider.getItemAt(i);
				sumValue += data[valueField];
				arrays.push(data[labelField]);
			}

		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if(redrawSkin && skin && doughnutHolder){
				redrawSkin = false;
				if (doughnuts.length > 0) {
					for (var i:int = 0; i < doughnuts.length; i++) {
						var p:Sprite = doughnuts[i] as Sprite;
						
						p.removeEventListener(MouseEvent.MOUSE_DOWN, handlerDoughnutMouseEvents);
						p.removeEventListener(MouseEvent.ROLL_OVER, handlerDoughnutMouseEvents);
					}
					doughnutHolder.removeChild(p);
				}
				
				doughnuts = [];
				for (i = 0; i < dataProvider.length; i++) {
					var dsp:DoughnutSprite = new DoughnutSprite();
					dsp.data = dataProvider.getItemAt(i);
					
					dsp.addEventListener(MouseEvent.MOUSE_DOWN, handlerDoughnutMouseEvents, false, 0 , true);
					dsp.addEventListener(MouseEvent.ROLL_OVER, handlerDoughnutMouseEvents, false, 0, true);
				    doughnutHolder.addChild(dsp);
					doughnuts.push(dsp);
				}
				
				if(skin){
					skin.invalidateProperties();
					skin.invalidateDisplayList();
				}
			}
		}
		
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w, h);
			
			var angle:int = 0;
			var outerRadius:Number;
			for(var i:int=0; i < dataProvider.length; i++){	
				//update data
				var doughnut:DoughnutSprite = doughnuts[i] as DoughnutSprite;
				doughnut.data = dataProvider.getItemAt(i);
				doughnut.getFill = dataProvider.getItemAt(i);	
				doughnut.data.sumValue = sumValue;
				doughnut.data.startAngle = angle;
				
				var fill:String = (doughnut.getFill[fillField] == null) ? '#DC2400': doughnut.getFill[fillField];
				var fillColor:String = (fill.search('#') == 0 || fill.search('#') == fill.indexOf(',')+1 || fill.search('#') == fill.indexOf(',')+2) ? fill.replace('#', '0x') : fill;
				doughnut.getFill.color = fillColor;

				angle += (doughnut.data[valueField] / sumValue * 360) + 1;
				outerRadius = (h- (marginTop*2 + marginBottom*2))/2

				doughnut.data.outerRadius = outerRadius;
				doughnut.data.innerRadius = outerRadius / 2;
				doughnut.data.arrays = arrays;
				doughnut.data.centerX = w/2;
				doughnut.data.centerY = h/2;
				doughnut.data.arcData = doughnut.data[valueField] / sumValue;
				//draw
				doughnut.draw();
			}
		}
		
		private function handlerDoughnutMouseEvents(evt:MouseEvent):void {
			var doughnut:DoughnutSprite = evt.target as DoughnutSprite;
			switch(evt.type) {
				case MouseEvent.MOUSE_DOWN:
						doughnut.animate(explodeDistance);
					break;
				case MouseEvent.ROLL_OVER:
						if(doughnut.hitTestPoint(evt.stageX,evt.stageY)){
							doughnut.showTooltip();
							doughnut.addEventListener(MouseEvent.ROLL_OUT, handlerDoughnutMouseEvents);
						}
					break;
				case MouseEvent.ROLL_OUT:
						doughnut.removeEventListener(MouseEvent.ROLL_OUT, handlerDoughnutMouseEvents);
						doughnut.hideTooltip();
					break;
			}
		}
		
		public function get labelField():String
		{
			return _labelField;
		}
		
		public function set labelField(value:String):void
		{
			_labelField = value;
		}
		
		public function get valueField():String
		{
			return _valueField;
		}
		
		public function set valueField(value:String):void
		{
			_valueField = value;
		}
		
		public function get data():Object
		{
			return _data;
		}
		
		public function set data(value:Object):void
		{
			_data = value;
		}
		
		public function get fillField():String
		{
			return _fillField;
		}

		public function set fillField(value:String):void
		{
			_fillField = value;
			redrawSkin = true;
			invalidateProperties();
		}
		
		public function get marginTop():Number 
		{
			return _marginTop;
		}
		
		public function set marginTop(value:Number):void 
		{
			_marginTop = value;
			redrawSkin = true;
			invalidateProperties();
		}
		
		public function get marginRight():Number 
		{
			return _marginRight;
		}
		
		public function set marginRight(value:Number):void 
		{
			_marginRight = value;
			redrawSkin = true;
			invalidateProperties();
		}
		
		public function get marginBottom():Number 
		{
			return _marginBottom;
		}
		
		public function set marginBottom(value:Number):void 
		{
			_marginBottom = value;
			redrawSkin = true;
			invalidateProperties();
		}
		
		public function get marginLeft():Number 
		{
			return _marginLeft;
		}
		
		public function set marginLeft(value:Number):void 
		{
			_marginLeft = value;
			redrawSkin = true;
			invalidateProperties();
		}
	}
}