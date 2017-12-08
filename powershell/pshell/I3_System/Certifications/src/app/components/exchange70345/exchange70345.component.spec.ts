import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { Exchange70345Component } from './exchange70345.component';

describe('Exchange70345Component', () => {
  let component: Exchange70345Component;
  let fixture: ComponentFixture<Exchange70345Component>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ Exchange70345Component ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(Exchange70345Component);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
