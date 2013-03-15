package fxrialab.controls.charts
{	
	import flash.display.Sprite;
	
	import mx.collections.IList;
	import mx.core.UIComponent;
	
	import spark.components.supportClasses.SkinnableComponent;
	
	public class CoordinateAxis extends SkinnableComponent
	{
		private var _dataProvider:IList;
		private var redrawSkin:Boolean = false;
		private var _labelField:String = "label";
		private var _valueField:String = "value";
		private var _orientation:String = 'horizontal';
		
		private var _maxValue:Number;
		private var _minValue:Number;
		private var _numberLineLandMarkDefault:Number;
		private var _numberLineLandMarkForNegativeAxis:Number;
		
		private var _title:String;
		private var _gap:Number;
		private var _marginTop:Number;
		private var _marginRight:Number;
		private var _marginBottom:Number;
		private var _marginLeft:Number;
		
		public function CoordinateAxis()
		{
			super();
			setStyle("skinClass", CoordinateAxisSkin);
		}	

		public function get dataProvider():IList
		{
			return _dataProvider;
		}

		public function set dataProvider(value:IList):void
		{
			if(value == _dataProvider) return;
			_dataProvider = value;
			redrawSkin = true;
			invalidateProperties();

		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if(redrawSkin) {
				redrawSkin = false;
				
				if(skin){
					skin.invalidateProperties();
					skin.invalidateDisplayList();
				}
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

		public function get orientation():String
		{
			return _orientation;
		}

		public function set orientation(value:String):void
		{
			_orientation = value;
		}
		
		public function get maxValue():Number
		{
			return _maxValue;
		}

		public function set maxValue(value:Number):void
		{
			_maxValue = value;
			redrawSkin = true;
			invalidateProperties();
		}
		
		public function get minValue():Number
		{
			return _minValue;
		}
		
		public function set minValue(value:Number):void
		{
			_minValue = value;
			redrawSkin = true;
			invalidateProperties();
		}

		public function get title():String
		{
			return _title;
		}

		public function set title(value:String):void
		{
			_title = value;
			redrawSkin = true;
			invalidateProperties()
		}

		public function get gap():Number
		{
			return _gap;
		}

		public function set gap(value:Number):void
		{
			_gap = value;
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

		public function get numberLineLandMarkDefault():Number
		{
			return _numberLineLandMarkDefault;
		}

		public function set numberLineLandMarkDefault(value:Number):void
		{
			_numberLineLandMarkDefault = value;
			redrawSkin = true;
			invalidateProperties();
		}

		public function get numberLineLandMarkForNegativeAxis():Number
		{
			return _numberLineLandMarkForNegativeAxis;
		}

		public function set numberLineLandMarkForNegativeAxis(value:Number):void
		{
			_numberLineLandMarkForNegativeAxis = value;
			redrawSkin = true;
			invalidateProperties();
		}


	}
}