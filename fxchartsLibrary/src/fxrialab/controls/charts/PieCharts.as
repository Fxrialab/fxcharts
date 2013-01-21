package fxrialab.controls.charts
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import mx.collections.IList;
	import mx.core.UIComponent;
	
	import spark.components.supportClasses.SkinnableComponent;
	
	[Style(name="tooltipFont", inherit="yes", type="String")]
	[Style(name="tooltipSize", inherit="yes", type="Number")]
	[Style(name="tooltipAlign", inherit="yes", type="String")]
	[Style(name="tooltipColor", inherit="yes", type="uint")]
	public class PieCharts extends SkinnableComponent
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
		
		public var pies:Array=[];
		public var explodeDistance:int = 10;
		
		[SkinPart]
		public var pieHolder:UIComponent;
		
		public function PieCharts()
		{
			super();
			mouseChildren = true;
			this.setStyle('skinClass', PieChartSkin);
			this.setStyle('tooltipFont', 'Time New Normal');
			this.setStyle('tooltipSize', 7);
			this.setStyle('tooltipAlign', 'center');
			this.setStyle('tooltipColor', 0xFFFFFF);
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
			
			for(var j:uint=0; j < dataProvider.length; j++){
				data = dataProvider.getItemAt(j);
				sumValue += data[valueField];
				arrays.push(data[labelField]);
			}
			
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if(redrawSkin && skin && pieHolder){
				redrawSkin = false;
				if(pies.length > 0){
					for(var i:int = 0; i < pies.length; i++){
						var p:Sprite = pies[i] as Sprite;
						
						p.removeEventListener(MouseEvent.MOUSE_DOWN, handlerPieMouseEvents);
						p.removeEventListener(MouseEvent.ROLL_OVER, handlerPieMouseEvents);
					}
					pieHolder.removeChild(p);
				}
				
				pies = [];
				for(i=0;i < dataProvider.length; i++){
					var psp:PieSprite = new PieSprite();
					psp.data = dataProvider.getItemAt(i);
					
					psp.addEventListener(MouseEvent.MOUSE_DOWN, handlerPieMouseEvents, false, 0, true);
					psp.addEventListener(MouseEvent.ROLL_OVER, handlerPieMouseEvents, false, 0, true);
					
					pieHolder.addChild(psp);
					pies.push(psp);
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
			var radius:Number;
			for(var i:int=0; i < dataProvider.length; i++){	
				//update data
				var pie:PieSprite = pies[i] as PieSprite;
				pie.data = dataProvider.getItemAt(i);
				pie.getFill = dataProvider.getItemAt(i);
				pie.data.sumValue = sumValue;
				pie.data.startAngle = angle;
				
				var fill:String = (pie.getFill[fillField] == null) ? '#DC2400': pie.getFill[fillField];
				var fillColor:String = (fill.search('#') == 0) ? fill.replace('#', '0x') : fill;
				pie.getFill.color = fillColor;
				//trace(fillColor);
				angle += (pie.data[valueField] / sumValue * 360)+0.5;
				radius = (h - (marginTop*2 + marginBottom*2))/2
				
				pie.data.radius = radius;
				pie.data.arrays = arrays;

				pie.data.centerX = w/2;
				pie.data.centerY = h/2;
				pie.data.arcData = pie.data[valueField] / sumValue;
				//draw
				pie.draw();
			}
		}
		
		private function handlerPieMouseEvents(evt:MouseEvent):void {
			var pie:PieSprite = evt.target as PieSprite;
			
			switch(evt.type) {
				case MouseEvent.MOUSE_DOWN:
						pie.animate(explodeDistance);
					break;
				case MouseEvent.ROLL_OVER:
						if(pie.hitTestPoint(evt.stageX,evt.stageY)){
							pie.showTooltip();
							pie.addEventListener(MouseEvent.ROLL_OUT, handlerPieMouseEvents);
						}
					break;
				case MouseEvent.ROLL_OUT:
						pie.removeEventListener(MouseEvent.ROLL_OUT, handlerPieMouseEvents);
						pie.hideTooltip();
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